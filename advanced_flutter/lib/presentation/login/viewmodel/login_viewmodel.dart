import 'dart:async';

import 'package:advanced_flutter/domain/usecase/login_usecase.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/common/freezed_data_classes.dart';
import 'package:dartz/dartz.dart';

class LoginViewModel extends BaseViewModel with LoginViewModelInputs,LoginViewModelOutpus{

// broadcast() for many listen to StreamCnotroller until not face BadStateError
  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();

var loginObject = LoginObject('','');
final LoginUseCase _loginUseCase;
LoginViewModel(this._loginUseCase);

  // inputs
  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
  }

  @override
  void start() {
    // TODO: implement start
  }
  
  @override
  Sink get inputPassword => _passwordStreamController.sink;
  
  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
  }
  
  @override
  setUsreName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
  }
  
  @override
  login() async{
    // fold from Either to return LEFT and RIGHT
    (await _loginUseCase.execute(LoginUseCaseInput(loginObject.userName,loginObject.password)))
      .fold((failure) => {
        // left -> (failure)
        print(failure.message)
      }, (data) => {
        // right -> (success)
      });
  }

   
  //outputs
  @override
  Stream<bool> get outIsPasswordVaild =>
    _passwordStreamController.stream.map((password) => _isPasswordValid(password));
  
  @override
  Stream<bool> get outIsUserNameVaild => 
    _userNameStreamController.stream.map((userName) => _isUserNameValid(userName));
  
  bool _isPasswordValid(String password){
  return password.isNotEmpty;
  }
  
  bool _isUserNameValid(String userName){
  return userName.isNotEmpty;
  }

}

abstract class LoginViewModelInputs{
  setUsreName(String userName);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
}

abstract class LoginViewModelOutpus{
  Stream<bool> get outIsUserNameVaild;
  Stream<bool> get outIsPasswordVaild;
}