import 'dart:io';
import 'package:dio/dio.dart';

const API_PATH = 'https://healthene-gateway-dev.intelliceed.cf/api/';
// private names
const AUTH_STORE = 'sAuth';
const AUTH_BEARER = 'Bearer ';
const AUTH_HEADER = 'Authorization';
const ACCESS_TOKEN = 'accessToken';
const REFRESH_TOKEN = 'refreshToken';
// permission stored in same way as a tokens
const ACCESS_SCOPE = 'scope';
const ACCESS_STORE = 'sPermissions';
const ACCESS_RESOURCES = 'resources';
const ACCESS_AUTHORITIES = 'authorities';

Dio _dio() {
    var dio = Dio();
    dio.options
        ..baseUrl = API_PATH
        ..headers = {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.cacheControlHeader: 'no-cache',
        };

    dio.interceptors
        ..add(InterceptorsWrapper(
            onRequest: (Options options) {
                print('onRequest');
                // return ds.resolve( Response(data:"xxx"));
                // return ds.reject( DioError(message: "eh"));
                return options;
            },
        ))
        ..add(LogInterceptor(responseBody: false)); // Open log;

    return dio;
}

Dio dio = _dio();
