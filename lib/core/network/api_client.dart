import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'https://pokeapi.co/api/v2/';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => debugPrint('[API] $obj'),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          try {
            final baseUri = Uri.parse(options.baseUrl);
            var uri = baseUri.resolveUri(Uri.parse(options.path));
            if (options.queryParameters.isNotEmpty) {
              final mergedQuery = Map<String, dynamic>.from(uri.queryParameters)
                ..addAll(options.queryParameters.map((key, value) {
                  if (value is Iterable) {
                    return MapEntry(key, value.map((v) => v.toString()));
                  }
                  return MapEntry(key, value.toString());
                }));
              uri = uri.replace(queryParameters: mergedQuery);
            }

            if (uri.host == 'pokeapi.co') {
              final encodedTarget = Uri.encodeComponent(uri.toString());
              options.baseUrl = 'https://api.codetabs.com/v1/proxy/?quest=$encodedTarget';
              options.path = '';
              options.queryParameters = {};
            }
          } catch (e) {
            debugPrint('[API Proxy Error] $e');
          }
          handler.next(options);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          handler.next(e);
        },
      ),
    );

    return dio;
  }
}

void debugPrint(String msg) {
  
  print(msg);
}
