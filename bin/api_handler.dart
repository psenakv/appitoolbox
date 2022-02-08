import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:shelf_plus/shelf_plus.dart';

import 'api_middleware.dart';

class ApiHandler {
  Future<Response> _universalGetHandler(Request request) async {
    Uri url = Uri.parse("https://" + request.params['url']!);
    print("got url");
    Map<String, String> headers = Map.from(request.headers);
    headers.remove("host");
    headers.addAll({
      "X-AppiToolbox-Original-User-Agent": headers["User-Agent"] ?? "Unknown",
      "X-AppiToolbox-Info": "Sent from AppiToolbox",
    });
    headers["User-Agent"] = "AppiToolbox";
    http.Response response = await http.get(url, headers: headers);
    Map<String, String> responseHeaders = Map.from(response.headers);
    responseHeaders.addAll({
      "X-AppiToolbox-Info": "Received from AppiToolbox",
    });
    responseHeaders.remove("transfer-encoding");
    responseHeaders.remove("content-encoding");
    return Response(response.statusCode,
        body: response.body, headers: responseHeaders);
  }

  Future<Response> _universalPostHandler(Request request) async {
    Uri url = Uri.parse("https://" + request.params['url']!);
    Map<String, String> headers = Map.from(request.headers);
    print(headers);
    headers.remove("host");
    headers.addAll({
      "X-AppiToolbox-Original-User-Agent": headers["User-Agent"] ?? "Unknown",
      "X-AppiToolbox-Info": "Sent from AppiToolbox",
    });
    headers["User-Agent"] = "AppiToolbox";
    String body = await request.readAsString();
    http.Response response = await http.post(
      url,
      //headers: headers,
      body: body,
    );

    Map<String, String> responseHeaders = response.headers;
    responseHeaders.addAll({"X-AppiToolbox-Info": "Received from AppiToolbox"});
    responseHeaders.remove("transfer-encoding");
    responseHeaders.remove("content-encoding");

    return Response(response.statusCode,
        body: response.body, headers: responseHeaders);
  }

  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router().plus;

    router
      ..get('/<url|.*>', _universalGetHandler, use: apiMiddleware())
      ..post('/<url|.*>', _universalPostHandler, use: apiMiddleware());

    return router.shelfRouter;
  }
}
