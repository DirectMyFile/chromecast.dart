import "package:google_cast/cast.dart";

main() async {
  var cast = new CastClient("192.168.2.12");

  await cast.connect();

  print("Connected.");

  var recv = cast.getReceiverChannel();

  var response = await recv.sendRequest({
    "type": "LAUNCH",
    "appId": "YouTube"
  });

  print(response.json);
}
