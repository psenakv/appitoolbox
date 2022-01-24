class EndpointConfig {
  String? title;
  String url;

  EndpointConfig({this.title, required this.url});

  factory EndpointConfig.fromJson(Map<String, dynamic> json) {
    if (json['url']! == null) {
      throw Exception("url is required");
    }
    return EndpointConfig(
      title: json['title'],
      url: json['url']!,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}
