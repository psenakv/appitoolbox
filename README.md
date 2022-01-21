# AppiToolbox

A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This is simple server app made as MVP to make easier developing mobile apps that comunicate with external REST API. It will enable logging all requests with specific headers (eg. debug headers), and at the end modify requests to be able to keep up to date with APIs without having to upgrade the app (eg. in the situation that someone breaks API you're using).

## Running the app

First, copy file .env.example to .env and change value of MASTER_API_KEY to some key you will use to connect.

### Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```text
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:

```text
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

### Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```text
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:

```text
curl -H "X-AppiToolbox-ApiKey: SOME_API_KEY" http://localhost:8080/apihandler/dummy.restapiexample.com/api/v1/employees
```

You should see the logging printed in the first terminal:

```text
2022-01-21T22:22:51.274950  0:00:00.962764 GET     [200] /apihandler/dummy.restapiexample.com/api/v1/employees
```
