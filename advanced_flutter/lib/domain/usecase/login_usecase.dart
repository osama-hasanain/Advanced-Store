import 'package:advanced_flutter/data/network/failure.dart';
import 'package:advanced_flutter/data/network/requests.dart';
import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/domain/repository/repository.dart';
import 'package:advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput,Authentication>{
  Repository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(LoginUseCaseInput input) async{
    return await _repository.login(LoginRequest(input.email, input.password));
  }

}

class LoginUseCaseInput{
  String email;
  String password;
  LoginUseCaseInput(this.email,this.password);
}