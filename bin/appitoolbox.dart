import 'dart:convert';
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

Middleware _jsonLogger({void Function(String message, bool isError)? logger}) =>
    (innerHandler) {
      return (request) {
        var startTime = DateTime.now();
        var watch = Stopwatch()..start();

        return Future.sync(() => innerHandler(request)).then((response) {
          Map<String, dynamic> log = {
            'severity': 'INFO',
            'time': startTime.toString(),
            'httpRequest': {
              'requestMethod': request.method,
              'requestUrl': request.requestedUri.toString(),
              'status': response.statusCode,
              'latency': (watch.elapsed.inMicroseconds / 1000000).toString(),
            },
          };
          print(jsonEncode(log));

          return response;
        }, onError: (Object error, StackTrace stackTrace) {
          if (error is HijackException) throw error;

          Map<String, dynamic> log = {
            'severity': 'ERROR',
            'time': startTime.toString(),
            'httpRequest': {
              'requestMethod': request.method,
              'requestUrl': request.requestedUri.toString(),
              'latency': (watch.elapsed.inMicroseconds / 1000000).toString(),
            },
          };
          print(jsonEncode(log));

          throw error;
        });
      };
    };

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final _handler = Pipeline().addMiddleware(_jsonLogger()).addHandler(_router);
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
