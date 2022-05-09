import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Projetao3/core/urls.dart';
import 'package:Projetao3/services/shared/api_routes.dart';

class TagsService {
  String _url = Urls.clusterServiceUrl;
  String _route = ApiRoutes.Tags;

  Future<Map> getSameClusterTags({String? tag}) async {
    String customUrl = this._url + this._route;

    var headers = _setHeaders();

    if (tag != null) {
      customUrl = customUrl + '/$tag';
    }

    Uri url = Uri.parse(customUrl);

    final response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return json.decode(response.body) as Map;
  }

  Map<String, String> _setHeaders() => {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
      };
}
