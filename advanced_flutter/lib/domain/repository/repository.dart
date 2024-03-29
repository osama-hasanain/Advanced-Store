import 'package:advanced_flutter/data/network/failure.dart';
import 'package:advanced_flutter/data/network/requests.dart';
import 'package:advanced_flutter/domain/model/models.dart';
import 'package:dartz/dartz.dart';

abstract class Repository{
  Future<Either<Failure,Authentication>> login(LoginRequest loginRequest);

  Future<Either<Failure,String>> forgetPassword(String email);

  Future<Either<Failure,Authentication>> register(RegisterRequest registerRequest);

  Future<Either<Failure,HomeObject>> getHomeData();
  Future<Either<Failure,Store>> getStoreDetails();

}