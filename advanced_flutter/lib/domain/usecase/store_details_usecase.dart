
import 'package:advanced_flutter/data/network/failure.dart';
import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/domain/repository/repository.dart';
import 'package:advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class StoreUseCase implements BaseUseCase<void,Store>{
  final Repository _repository;
  StoreUseCase(this._repository);

  @override
  Future<Either<Failure, Store>> execute(void input) async{
    return await _repository.getStoreDetails();
  }

}