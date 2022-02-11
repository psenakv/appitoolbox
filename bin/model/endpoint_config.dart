enum Status { blocked, allowed, undefined }

enum Method {
  get,
  head,
  post,
  put,
  delete,
  connect,
  options,
  trace,
  patch,
  undefined,
  all
}

class EndpointConfig {
  String title;
  String url;
  Method method;
  Status status;

  EndpointConfig(
      {required this.title,
      required this.url,
      required this.method,
      required this.status});

  factory EndpointConfig.fromJson(Map<String, dynamic> json) {
    late Status status;
    late Method method;
    if (json['title'] == null) {
      throw Exception("Title is required");
    }
    if (json['url'] == null) {
      throw Exception("URL is required");
    }
    if (json['method'] == null) {
      throw Exception("Method is required");
    } else {
      try {
        method = Method.values.byName(json['method']!);
      } catch (e) {
        throw Exception("Method is invalid");
      }
    }
    if (json['status'] == null) {
      throw Exception("Status is required");
    } else {
      try {
        status = Status.values.byName(json['status']!);
      } catch (e) {
        throw Exception("Status is invalid");
      }
    }

    return EndpointConfig(
        title: json['title']!,
        url: json['url']!,
        method: method,
        status: status);
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
