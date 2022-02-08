import 'dart:convert';
import 'dart:io';

import '../model/endpoint_config.dart';

class EndpointConfigService {
  List<EndpointConfig> configs = [];
  var defaultConfig = new File('./config/example.json');
  bool loaded = false;

  Future init() async {
    await _loadEndpoints();
    loaded = true;
  }

  Future _loadEndpoints() async {
    final json = jsonDecode(await defaultConfig.readAsString());
    for (var item in json["endpoints"]) {
      configs.add(EndpointConfig.fromJson(item));
    }
    return true;
  }

  Status statusByUrl(String url) {
    if (!loaded) {
      throw new Exception("You need to load config first");
    }
    for (var item in configs) {
      if (item.url == url) {
        return item.status;
      }
      if (item.url == "https://" + url) {
        return item.status;
      }
      if (item.url == "http://" + url) {
        return item.status;
      }
    }
    return Status.undefined;
  }
}
