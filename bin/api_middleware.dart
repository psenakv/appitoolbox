import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'model/endpoint_config.dart';
import 'utils/globals.dart' as globals;
import 'package:dotenv/dotenv.dart' as dotenv;

Middleware apiMiddleware({
  FutureOr<Response?> Function(Request)? requestHandler,
  FutureOr<Response> Function(Response)? responseHandler,
  FutureOr<Response> Function(Object error, StackTrace)? errorHandler,
}) {
  requestHandler ??= (request) => null;
  responseHandler ??= (response) => response;

  FutureOr<Response> Function(Object, StackTrace)? onError;
  if (errorHandler != null) {
    onError = (error, stackTrace) {
      if (error is HijackException) throw error;
      return errorHandler(error, stackTrace);
    };
  }

  return (Handler innerHandler) {
    return (request) {
      if (request.headers['X-AppiToolbox-ApiKey'] == null) {
        return Response.forbidden(
            'No API Key provided. Use header X-AppiToolbox-ApiKey');
      }
      if (request.headers['X-AppiToolbox-ApiKey'] !=
          dotenv.env['MASTER_API_KEY']) {
        return Response.forbidden('Wrong value of X-AppiToolbox-ApiKey');
      }
      if (request.params['url'] == null) {
        return Response.notFound("You must supply valid URL.");
      }

      String requestedEndpoint = request.params['url']!;

      if (globals.configService.statusByUrl(requestedEndpoint) ==
          Status.blocked) {
        return Response.forbidden("This endpoint is blocked.");
      }

      return Future.sync(() => requestHandler!(request)).then((response) {
        if (response != null) return response;

        return Future.sync(() => innerHandler(request))
            .then((response) => responseHandler!(response), onError: onError);
      });
    };
  };
}
