import '../model/endpoint_config.dart';
import '../model/method.dart';
import '../model/status.dart';
import '../utils/globals.dart' as globals;

class EndpointConfigService {
  List<EndpointConfig> configs = [];
  bool loaded = false;

  Future init() async {
    await _loadEndpoints();
    loaded = true;
  }

  Future _loadEndpoints() async {
    if (!globals.configLoaded) {
      await globals.loadConfig();
    }
    final json = globals.config;
    for (var item in json["endpoints"]) {
      configs.add(EndpointConfig.fromJson(item));
    }
    return true;
  }

  Status endpointStatus(String url, String methodS) {
    Method method;
    try {
      method = Method.values.byName(methodS.toLowerCase());
    } catch (e) {
      method = Method.undefined;
    }
    if (!loaded) {
      throw Exception("You need to load config first");
    }
    for (var item in configs) {
      if (item.method != method &&
          item.method != Method.undefined &&
          item.method != Method.all) {
        break;
      }
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
