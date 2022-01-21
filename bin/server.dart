import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/handler/<url|.*>', _universalGetHandler)
  ..post('/handler/<url|.*>', _universalPostHandler);

Response _rootHandler(Request req) {
  return Response.notFound("Page not found.");
}

Future<Response> _universalGetHandler(Request request) async {
  print("get handler");
  print(request.params['url']);
  if (request.params['url'] == null) {
    return Response.notFound("You must supply valid URL.");
  }
  Uri url = Uri.parse("https://" + request.params['url']!);
  Map<String, String> headers = Map.from(request.headers);
  headers.remove("host");
  headers.addAll({
    "X-AppiToolbox-Original-User-Agent": headers["User-Agent"] ?? "Unknown",
    "X-AppiToolbox-Info": "Sent from AppiToolbox",
  });
  headers["User-Agent"] = "AppiToolbox";
  http.Response response = await http.get(url, headers: headers);

  Map<String, String> responseHeaders = response.headers;
  responseHeaders.addAll({
    "X-AppiToolbox-Info": "Received from AppiToolbox",
  });

  return Response(response.statusCode,
      body: response.body, headers: responseHeaders);
}

Future<Response> _universalPostHandler(Request request) async {
  print(request.params['url']);
  if (request.params['url'] == null) {
    return Response.notFound("You must supply valid URL.");
  }
  Uri url = Uri.parse("https://" + request.params['url']!);
  Map<String, String> headers = Map.from(request.headers);
  headers.remove("host");
  headers.addAll({
    "X-AppiToolbox-Original-User-Agent": headers["User-Agent"] ?? "Unknown",
    "X-AppiToolbox-Info": "Sent from AppiToolbox",
  });
  headers["User-Agent"] = "AppiToolbox";
  String body = await request.readAsString();
  http.Response response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  Map<String, String> responseHeaders = response.headers;
  responseHeaders.addAll({
    "X-AppiToolbox-Info": "Received from AppiToolbox",
  });

  return Response(response.statusCode,
      body: response.body, headers: responseHeaders);
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
