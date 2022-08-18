import 'package:advanced_flutter/app/constants.dart';
import 'package:advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:advanced_flutter/data/mapper/mapper.dart';
import 'package:advanced_flutter/data/network/error_handler.dart';
import 'package:advanced_flutter/data/network/network_info.dart';
import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/data/network/requests.dart';
import 'package:advanced_flutter/data/network/failure.dart';
import 'package:advanced_flutter/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements Repository{
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource,this._networkInfo);  

  @override
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest)async{
    if(await _networkInfo.isConnected){
      //its connected to inernet, its safe to call API
      try{
        final response = await _remoteDataSource.login(loginRequest);
        if(response.status == ApiInternalStatus.SUCCESS){
          return Right(response.toDomain());
        }else{
          return Left(Failure(ApiInternalStatus.FAILURE,response.message??ResponseMessage.DEFUALT));
        }
      }catch(error){
        return Left(ErrorHandler.handle(error).failure);
      }
    }else{
      // return internet connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
  
}