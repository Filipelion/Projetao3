import 'dart:convert';

import 'package:http/http.dart' as http;

class ServerIntegration {
  String _url = "http://cf0e9dafb661.ngrok.io";
  String _route = "/teste";

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
    return response.body;
  }
}
