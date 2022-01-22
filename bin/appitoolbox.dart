import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

import 'api_handler.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..mount('/apihandler/', ApiHandler().router);

Response _rootHandler(Request req) {
  return Response.notFound("Page not found.");
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  dotenv.load();
  print('Server listening on port ${server.port}');

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    print("\nStopping server...");
    server.close();
    print("Exiting...");
    exit(0);
  });
}
