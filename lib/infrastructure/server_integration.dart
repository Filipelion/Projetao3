import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerIntegration {
  String _url = "http://9f14d689b57b.ngrok.io";
  String _route = "/tags";

  getSameClusterTags({String tag}) async {
    String customUrl = this._url + this._route;
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    if (tag != null) {
      customUrl = customUrl + '/$tag';
    }

    final response = await http.get(customUrl, headers: headers);
    return json.decode(response.body) as Map;
  }
}
