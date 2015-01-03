library chromecast;

import "dart:io";
import "dart:async";
import "dart:typed_data";
import "dart:convert";
import "package:chromecast/cast.pb.dart";
import "package:protobuf/protobuf.dart" show CodedBufferReader;

class CastChannel {
  final Chromecast cast;
  final String namespace;
  final String sender;
  final String receiver;

  CastChannel(this.cast, this.namespace, this.sender, this.receiver);

  void send(Map<String, dynamic> json) {
    cast.sendJSON(namespace, json, sender, receiver);
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
        print("Got Packet");
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
          print("PONG!");
        }
      });

      _timer = new Timer.periodic(new Duration(seconds: 1), (_) {
        _heartbeat.send({
          "type": "PING"
        });
      });

      _heartbeat.send({
        "type": "PING"
      });
    });
  }

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
    
    print("SEND: source=${msg.sourceId} destination=${msg.destinationId} namespace=${msg.namespace} payloadType=${msg.payloadType.name} protocolVersion=${msg.protocolVersion.value} data=${msg.payloadUtf8}");
    
    sendBuffer(msg.writeToBuffer());
  }

  void sendBuffer(Uint8List data) {
    var bytes = data.buffer.asUint32List();
    
    _socket.add((new ByteData(4)..setUint32(0, bytes.lengthInBytes)).buffer.asUint32List());
    
    var buff = new ByteData(bytes.lengthInBytes);
    
    int offset = 0;
    for (var byte in bytes) {
      buff.setUint32(offset, byte, Endianness.BIG_ENDIAN);
      offset += 4;
    }
    _socket.add(buff.buffer.asUint32List());
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
      print("Got Data");
      
      if (state == 0) {
        length = new CodedBufferReader(data).readUint32();
        state = 1;
      } else if (state == 1) {
        var packet = new Packet(length, new CodedBufferReader(data).readBytes());
        controller.add(packet);
        state = 0;
      }
    });
    
    return controller.stream;
  }
}