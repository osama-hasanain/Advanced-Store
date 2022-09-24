import 'package:advanced_flutter/data/network/failure.dart';
import 'package:advanced_flutter/domain/repository/repository.dart';
import 'package:advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ForgetPasswordUseCase implements BaseUseCase<String,String>{
  Repository _repository;
  ForgetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> execute(String email) async{
    print('ForgetPasswordUseCase $email');
    return await _repository.forgetPassword(email);
  }

}
