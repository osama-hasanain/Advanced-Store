import 'package:advanced_flutter/app/constants.dart';
import 'package:advanced_flutter/data/network/failure.dart';
import 'package:dio/dio.dart';


class ErrorHandler implements Exception{
  late Failure failure;
  
  ErrorHandler.handle(dynamic error){
    if(error is DioError){
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    }else{
      // defualt error
      failure = DataSource.DEFUALT.getFailure();
    }
  }
}

Failure _handleError(DioError error){
  switch(error.type){
    case DioErrorType.connectTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioErrorType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioErrorType.receiveTimeout:
      return DataSource.RECIEVE_TIMOUT.getFailure();
    case DioErrorType.response:
    if(error.response!=null&&error.response?.statusCode!=null&&error.response?.statusMessage!=null){
      return Failure(error.response?.statusCode??Constants.zero,error.response?.statusMessage??Constants.empty);
    }else{
      return DataSource.DEFUALT.getFailure();
    }
    case DioErrorType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioErrorType.other:
      return DataSource.DEFUALT.getFailure();
  }
}

enum DataSource{
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFUALT
}

extension DataSourceExtension on DataSource{
  Failure getFailure(){
    switch(this){
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);    
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST); 
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN); 
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED); 
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND); 
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR, ResponseMessage.INTERNAL_SERVER_ERROR); 
      case DataSource.CONNECT_TIMEOUT:
        return Failure(ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT); 
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL); 
      case DataSource.RECIEVE_TIMOUT:
        return Failure(ResponseCode.RECIEVE_TIMOUT, ResponseMessage.RECIEVE_TIMOUT); 
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT); 
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR); 
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION, ResponseMessage.NO_INTERNET_CONNECTION); 
      case DataSource.DEFUALT:
        return Failure(ResponseCode.DEFUALT, ResponseMessage.DEFUALT); 
    }
  }
}

class ResponseCode{
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; //success with no data(no coennect)
  static const int BAD_REQUEST = 400;// failure,API rejected request
  static const int UNAUTORISED = 401;//failure, user is not authorised
  static const int FORBIDDEN = 403;// failure,API rejected request 
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found

  //local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFUALT = -7;
}

class ResponseMessage{
  static const String SUCCESS = 'success'; // success with data
  static const String NO_CONTENT = 'success'; //success with no data(no coennect)
  static const String BAD_REQUEST = 'Bad request, Try again later';// failure,API rejected request
  static const String UNAUTORISED = 'User is unaithorised, Try again later';//failure, user is not authorised
  static const String FORBIDDEN = 'Forbidden request, Try again later' ;// failure,API rejected request 
  static const String INTERNAL_SERVER_ERROR = 'Some thing went wrong, Try again later'; // failure, crash in server side
  static const String NOT_FOUND = 'Some thing went wrong, Try again later'; // failure, crash in server side

  //local status code
  static const String CONNECT_TIMEOUT = 'Time out error, Try again later';
  static const String CANCEL = 'Request was cancel, Try again later';
  static const String RECIEVE_TIMOUT = 'Time out error, Try again later';
  static const String SEND_TIMEOUT = 'Time out error, Try again later';
  static const String CACHE_ERROR = 'Cache error, Try again later';
  static const String NO_INTERNET_CONNECTION = 'Please check your internet connection';
  static const String DEFUALT = 'Some thing went wrong, Try again later';
}

class ApiInternalStatus{
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}