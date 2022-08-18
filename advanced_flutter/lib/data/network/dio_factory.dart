import 'package:advanced_flutter/app/app_prefs.dart';
import 'package:advanced_flutter/app/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String AUTHORIZATION = 'authorization';
const String DEFAULT_LNAGUAGE = 'language';

class DioFactory{

  AppPreferences _appPreferences;
  DioFactory(this._appPreferences);

  Future<Dio> getDio() async{
    Dio dio = Dio();

    String language = await _appPreferences.getAppLanguage();
    Map<String,String> headres = {
      CONTENT_TYPE:APPLICATION_JSON,
      ACCEPT:APPLICATION_JSON,
      AUTHORIZATION:Constants.token,
      DEFAULT_LNAGUAGE:language 
    };

    dio.options = BaseOptions(
      baseUrl:  Constants.baseUrl,
      headers:  headres,
      receiveTimeout: Constants.apiTImeOut,
      sendTimeout: Constants.apiTImeOut);

      if(!kReleaseMode){ // its debug mode so print add logs
        dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true
        ));
      }

    return dio;
  }
}