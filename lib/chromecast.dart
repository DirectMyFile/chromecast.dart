library chromecast;

import "dart:io";
import "dart:async";
import "dart:typed_data";
import "dart:convert";
import "package:chromecast/cast.pb.dart";

class CastChannel {
  final Chromecast cast;
  final String namespace;
  final String sender;
  final String receiver;

  int _reqId = 0;

  CastChannel(this.cast, this.namespace, this.sender, this.receiver);

  void send(Map<String, dynamic> json) {
    cast.sendJSON(namespace, json, sender, receiver);
  }

  Future<CastJSONMessage> sendRequest(Map<String, dynamic> input) {
    var id = _reqId++;
    input["requestId"] = id;
    cast.sendJSON(namespace, input, sender, receiver);
    return onMessage.where((it) {
      return it.json["requestId"] == id;
    }).first;
  }

  Stream<CastJSONMessage> get onMessage => cast.onMessage.where((it) {
    return it.namespace == namespace;
  }).map((msg) {
    return new CastJSONMessage(this, msg.sourceId, msg.destinationId, JSON.decode(msg.payloadUtf8));
  });
}

class CastJSONMessage {
  final CastChannel channel;
  final String source;
  final String destination;
  final Map<String, dynamic> json;

  CastJSONMessage(this.channel, this.source, this.destination, this.json);

  void reply(Map<String, dynamic> msg) {
    channel.send(msg);
  }
}

class Chromecast {
  final String host;

  Chromecast(this.host);

  CastChannel _heartbeat;
  CastChannel _connection;
  SecureSocket _socket;
  Timer _timer;

  StreamController<CastMessage> _msgController = new StreamController.broadcast();
  Stream<CastMessage> get onMessage => _msgController.stream;

  Future connect() {
    return Socket.connect(host, 8009).then((socket) {
      return SecureSocket.secure(socket, sendClientCertificate: true, onBadCertificate: (cert) {
        return true;
      });
    }).then((socket) {
      _socket = socket;

      socket.transform(new PacketStreamTransformer()).listen((Packet packet) {
        _msgController.add(new CastMessage.fromBuffer(packet.data));
      });
    }).then((_) {
      _connection = getChannel("sender-0", "receiver-0", "urn:x-cast:com.google.cast.tp.connection");
      _connection.send({
        "type": "CONNECT"
      });
      _heartbeat = getChannel("sender-0", "receiver-0", "urn:x-cast:com.google.cast.tp.heartbeat");

      _heartbeat.onMessage.listen((msg) {
        if (msg.json["type"] == "PONG") {
          _sentPong = true;
        }
      });

      _timer = new Timer.periodic(new Duration(seconds: 3), (_) {
        if (!_sentPong && _lastSentPing != null && new DateTime.now().millisecondsSinceEpoch - _lastSentPing.millisecondsSinceEpoch >= 8000) {
          throw new Exception("Chromecast Timed Out");
        }

        _sentPong = false;
        _ping();
      });

      _ping();
    });
  }

  void _ping() {
    _heartbeat.send({
      "type": "PING"
    });
    _lastSentPing = new DateTime.now();
  }

  DateTime _lastSentPing;
  bool _sentPong = false;

  CastChannel getReceiverChannel() {
    return getChannel("sender-0", "receiver-0", "urn:x-cast:com.google.cast.receiver");
  }

  CastChannel getChannel(String sender, String receiver, String namespace) {
    return new CastChannel(this, namespace, sender, receiver);
  }

  void sendJSON(String namespace, Map<String, dynamic> data, String source, String destination) {
    var msg = new CastMessage();
    msg.namespace = namespace;
    msg.payloadUtf8 = UTF8.decode(new JsonUtf8Encoder().convert(data));
    msg.destinationId = destination;
    msg.sourceId = source;
    msg.payloadType = CastMessage_PayloadType.STRING;
    msg.protocolVersion = CastMessage_ProtocolVersion.CASTV2_1_0;

    sendBuffer(msg.writeToBuffer());
  }

  void sendBuffer(Uint8List data) {
    var bytes = data;

    var header = (new ByteData(4)..setUint32(0, bytes.lengthInBytes, Endianness.BIG_ENDIAN)).buffer.asUint8List();
    _socket.add([]
        ..addAll(header)
        ..addAll(bytes));
  }
}

class Packet {
  final int length;
  final List<int> data;

  Packet(this.length, this.data);
}

class PacketStreamTransformer implements StreamTransformer<List<int>, Packet> {

  @override
  Stream<Packet> bind(Stream<List<int>> stream) {
    var controller = new StreamController<Packet>();
    var state = 0;
    var length = -1;

    stream.listen((data) {
      if (state == 0) {
        length = _bytesToInteger(data);
        state = 1;
      } else if (state == 1) {
        var packet = new Packet(length, data);
        if (data.length != length) {
          throw new Exception("Invalid packet length. Expected ${data.length} but they sent ${length}.");
        }
        controller.add(packet);
        state = 0;
      }
    });

    return controller.stream;
  }

  int _bytesToInteger(List<int> bytes) {
    Uint8List list = new Uint8List(4);
    list[0] = bytes[0];
    list[1] = bytes[1];
    list[2] = bytes[2];
    list[3] = bytes[3];
    return list.buffer.asByteData().getInt32(0);
  }
}
