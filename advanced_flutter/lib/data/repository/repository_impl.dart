import 'package:advanced_flutter/data/data_source/local_data_source.dart';
import 'package:advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:advanced_flutter/data/mapper/mapper.dart';
import 'package:advanced_flutter/data/network/error_handler.dart';
import 'package:advanced_flutter/data/network/network_info.dart';
import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/data/network/requests.dart';
import 'package:advanced_flutter/data/network/failure.dart';
import 'package:advanced_flutter/domain/repository/repository.dart';
import 'package:advanced_flutter/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements Repository{
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _lcoalDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource,this._networkInfo,this._lcoalDataSource);  

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

  @override
  Future<Either<Failure, String>> forgetPassword(String email)async{
    if(await _networkInfo.isConnected){
      //its connected to inernet, its safe to call API
      try{
        final response = await _remoteDataSource.forgetPassword(email);
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
  
  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest regsiterRequest)async {
    if(await _networkInfo.isConnected){
        //its connected to inernet, its safe to call API
        try{
          final response = await _remoteDataSource.register(regsiterRequest);
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
    
      @override
      Future<Either<Failure, HomeObject>> getHomeData() async{

        try{
          // get response from cache
           final response = await _lcoalDataSource.getHomeData();
           return Right(response.toDomain());
        }catch(cacheError){
        //   // cache is no exising or cache is not valid 

          //its thw time is to get from API side
          if(await _networkInfo.isConnected){
            //its connected to inernet, its safe to call API
            try{
              final response = await _remoteDataSource.getHomeData();
              if(response.status == ApiInternalStatus.SUCCESS){
                //save response in cache
                _lcoalDataSource.saveHomeToCache(response);

                return Right(response.toDomain());
              }else{
                print('Exception ${response.message??ResponseMessage.DEFUALT}');
                return Left(Failure(ApiInternalStatus.FAILURE,response.message??ResponseMessage.DEFUALT));
              }
            }catch(error){
                print('Exception ${error}');
              return Left(ErrorHandler.handle(error).failure);
            }
          }else{
            // return internet connection error
                print('Exception ${DataSource.NO_INTERNET_CONNECTION.getFailure()}');
            return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
          }
        }
 
      }

      
      @override
      Future<Either<Failure, Store>> getStoreDetails() async{

        // try{
        //   // get response from cache
        //    final response = await _lcoalDataSource.getHomeData();
        //    return Right(response.toDomain());
        // }catch(cacheError){
        //   // cache is no exising or cache is not valid 

          //its thw time is to get from API side
          if(await _networkInfo.isConnected){
            //its connected to inernet, its safe to call API
            try{
              final response = await _remoteDataSource.getStoreDetails();
              if(response.status == ApiInternalStatus.SUCCESS){
                //save response in cache
                //_lcoalDataSource.saveHomeToCache(response);

                return Right(response.toDomain());
              }else{
                print('Exception ${response.message??ResponseMessage.DEFUALT}');
                return Left(Failure(ApiInternalStatus.FAILURE,response.message??ResponseMessage.DEFUALT));
              }
            }catch(error){
                print('Exception ${error}');
              return Left(ErrorHandler.handle(error).failure);
            }
          }else{
            // return internet connection error
                print('Exception ${DataSource.NO_INTERNET_CONNECTION.getFailure()}');
            return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
          }
       // }
       
      }
  
}