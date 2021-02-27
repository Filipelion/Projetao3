import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerIntegration {
String _url = "http://dd8b4b1ff163.ngrok.io";
  String _route = "/tags";

  Future<Map> getSameClusterTags({String tag}) async {
    String customUrl = this._url + this._route;
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    if (tag != null) {
      customUrl = customUrl + '/$tag';
    }

    final response = await http.get(customUrl, headers: headers);
    print(json.decode(response.body));
    return json.decode(response.body) as Map;
  }
}
