import 'endpoint_config.dart';
import 'status.dart';

class GlobalConfig {
  Status defaultStatus;
  List<EndpointConfig> defaultEndpoints;

  GlobalConfig({
    required this.defaultStatus,
    required this.defaultEndpoints,
  });

  factory GlobalConfig.fromJson(Map<String, dynamic> json) {
    Status defaultStatus;
    if (json['defaultStatus'] == null) {
      throw Exception("defaultStatus is required");
    } else {
      try {
        defaultStatus = Status.values.byName(json['defaultStatus']!);
      } catch (e) {
        throw Exception("defaultStatus have invalid value");
      }
    }

    return GlobalConfig(
      defaultStatus: defaultStatus,
      defaultEndpoints: (json['defaultEndpoints'] as List<dynamic>)
          .map((e) => EndpointConfig.fromJson(e as Map<String, dynamic>,
              isDefault: true))
          .toList(),
    );
  }
}
