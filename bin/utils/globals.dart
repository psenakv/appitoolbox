import 'dart:convert';
import 'dart:io';

import '../services/endpoint_config.dart';
import '../services/global_config.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

EndpointConfigService endpointConfigService = EndpointConfigService();
GlobalConfigService globalConfigService = GlobalConfigService();
late Map config;
bool configLoaded = false;

loadConfig() async {
  String configPath = dotenv.env['CONFIG_FILE'] ?? "./config/example.json";
  File configFile = File(configPath);
  config = jsonDecode(await configFile.readAsString());
  configLoaded = true;
}
