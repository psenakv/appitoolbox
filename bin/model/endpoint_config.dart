import 'method.dart';
import 'status.dart';

class EndpointConfig {
  String? title;
  String? url;
  Method method;
  Status status;
  bool isDefault;

  EndpointConfig(
      {this.title,
      this.url,
      this.method = Method.undefined,
      this.status = Status.undefined,
      this.isDefault = false});

  factory EndpointConfig.fromJson(Map<String, dynamic> json,
      {bool isDefault = false}) {
    late Status status;
    late Method method;
    if (json['title'] == null && !isDefault) {
      throw Exception("Title is required");
    }
    if (json['url'] == null && !isDefault) {
      throw Exception("URL is required");
    }
    if (json['method'] == null) {
      method = Method.undefined;
    } else {
      try {
        method = Method.values.byName(json['method']!);
      } catch (e) {
        method = Method.undefined;
      }
    }
    if (json['status'] == null) {
      status = Status.undefined;
    } else {
      try {
        status = Status.values.byName(json['status']!);
      } catch (e) {
        status = Status.undefined;
      }
    }

    return EndpointConfig(
        title: json['title'],
        url: json['url'],
        method: method,
        status: status,
        isDefault: isDefault);
  }

  Status? getStatusFromString(String status) {
    status = 'Status.$status';
    return Status.values.firstWhere((f) => f.toString() == status,
        orElse: () => Status.undefined);
  }

  Method? getMethodFromString(String method) {
    method = 'Method.$method';
    return Method.values.firstWhere((f) => f.toString() == method,
        orElse: () => Method.undefined);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}
