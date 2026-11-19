import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Konfigurasi Dio Client (Best Practice)
/// Mengatur Timeout, Headers, dan Interceptor untuk Logging & Debugging
class DioClient {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Membuat instance Dio dengan konfigurasi standar industri
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      // Menambahkan Interceptor untuk keperluan logging dan pembelajaran
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint(' [HTTP REQUEST] ${options.method} => ${options.uri}');
            if (options.data != null) {
              debugPrint(' [BODY] ${options.data}');
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
            if (kDebugMode) {
              debugPrint(
                'berhasil [HTTP RESPONSE ${response.statusCode}] <= ${response.requestOptions.uri}',
              );
            }
            return handler.next(response);
          },
          onError: (DioException error, handler) {
            if (kDebugMode) {
              debugPrint(
                'gagal [HTTP ERROR ${error.response?.statusCode}] ${error.message} on ${error.requestOptions.uri}',
              );
            }
            return handler.next(error);
          },
        ),
      );
    }

    return dio;
  }
}
