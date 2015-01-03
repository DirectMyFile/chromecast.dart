import "package:chromecast/chromecast.dart";

void main() {
  var cast = new Chromecast("192.168.2.11");

  cast.connect().then((_) {
    print("Connected.");

    var recv = cast.getReceiverChannel();
    
    recv.send({
      "type": "LAUNCH",
      "application": "YouTube"
    });
  });
}