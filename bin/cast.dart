import "package:chromecast/chromecast.dart";

void main() {
  var cast = new Chromecast("192.168.2.11");

  cast.connect().then((_) {
    print("Connected.");

    var recv = cast.getReceiverChannel();

    recv.sendRequest({
      "type": "LAUNCH",
      "appId": "YouTube"
    }).then((msg) {
      print(msg.json);
    });
  });
}