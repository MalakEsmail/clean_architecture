import 'dart:convert';
import 'dart:io';
import 'package:clean_arch_pro/src/core/api/api_consumer.dart';
import 'package:clean_arch_pro/src/core/api/api_interceptor.dart';
import 'package:clean_arch_pro/src/core/api/status_code.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:clean_arch_pro/injection_container.dart' as di;
import 'end_points.dart';
import 'package:clean_arch_pro/src/core/error/exceptions.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..validateStatus = (status) {
        return status != null && status >= 200 && status < 300;
      };
    client.interceptors.add(di.sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(di.sl<LogInterceptor>());
    }
    ;
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await client.get(path, queryParameters: queryParams);
      return jsonDecode(response.data.toString());
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(String path, {Map<String, dynamic>? queryParams, Map<String, dynamic>? body}) async {
    try {
      final response = await client.post(path, queryParameters: queryParams, data: body);
      return jsonDecode(response.data.toString());
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(String path, {Map<String, dynamic>? queryParams, Map<String, dynamic>? body}) async {
    try {
      final response = await client.put(path, queryParameters: queryParams, data: body);
      return jsonDecode(response.data.toString());
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const FetchDataException();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw const UnauthorizedException();
          case StatusCode.notFound:
            throw const NotFoundException();
          case StatusCode.conflict:
            throw const ConflictException();

          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
        }
        break;
      case DioExceptionType.cancel:
        throw const NoInternetConnectionException();
      case DioExceptionType.unknown:
        throw const NoInternetConnectionException();
      default:
        throw const NoInternetConnectionException();
    }
  }
}
