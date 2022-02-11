import 'dart:convert';
import 'dart:io';

import '../model/global_config.dart';
import '../model/method.dart';
import '../model/status.dart';

class GlobalConfigService {
  late GlobalConfig globalConfig;
  var defaultConfig = File('./config/example.json');
  bool loaded = false;

  Future init() async {
    await loadConfig();
    loaded = true;
  }

  Future loadConfig() async {
    final json = jsonDecode(await defaultConfig.readAsString());
    globalConfig = GlobalConfig.fromJson(json["global"]);
  }

  Status defaultStatus(String methodS) {
    Method method;
    try {
      method = Method.values.byName(methodS.toLowerCase());
    } catch (e) {
      method = Method.undefined;
    }
    if (!loaded) {
      throw Exception("You need to load config first");
    }
    try {
      return globalConfig.defaultEndpoints
          .firstWhere((endpoint) => endpoint.method == method)
          .status;
    } catch (e) {
      return globalConfig.defaultStatus;
    }
  }
}
