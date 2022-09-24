import 'dart:async';
import 'package:advanced_flutter/domain/usecase/login_usecase.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/common/freezed_data_classes.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';

class LoginViewModel extends BaseViewModel with LoginViewModelInputs,LoginViewModelOutpus{

// broadcast() for many listen to StreamCnotroller until not face BadStateError
  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();
  final StreamController _areAllInputsValidController = StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccessfullyStreamController = StreamController<bool>();

var loginObject = LoginObject('','');
final LoginUseCase _loginUseCase;
LoginViewModel(this._loginUseCase);

  // inputs
  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // view model should tell view please show content state
    inputState.add(ContentState());
  }
  
  @override
  Sink get inputPassword => _passwordStreamController.sink;
  
  @override
  Sink get inputUserName => _userNameStreamController.sink;

    @override
  Sink get inputAreAllValid => _areAllInputsValidController.sink;
  


  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllValid.add(null);
  }
  
  @override
  setUsreName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllValid.add(null);
  }
  
  @override
  login() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    //fold from Either to return LEFT and RIGHT
    (await _loginUseCase.execute(LoginUseCaseInput(loginObject.userName,loginObject.password)))
      .fold((failure) => {
        // left -> (failure)
         inputState.add(ErrorState(stateRendererType: StateRendererType.popupErrorState,message: failure.message))
      }, (data)  {
        // right -> (success)
        inputState.add(ContentState());
      
        //navigate to main screen
        isUserLoggedInSuccessfullyStreamController.add(true);
      });
  }

   
  //outputs
  @override
  Stream<bool> get outIsPasswordVaild =>
    _passwordStreamController.stream.map((password) => _isPasswordValid(password));
  
  @override
  Stream<bool> get outIsUserNameVaild => 
    _userNameStreamController.stream.map((userName) => _isUserNameValid(userName));

     @override
  Stream<bool> get outAreAllValid =>
   _areAllInputsValidController.stream.map((_) => _areAllInputsValid());
  
  bool _isPasswordValid(String password){
  return password.isNotEmpty;
  }
  
  bool _isUserNameValid(String userName){
  return userName.isNotEmpty;
  }

  bool _areAllInputsValid(){
    return _isPasswordValid(loginObject.password)&&_isUserNameValid(loginObject.userName);
  }

}

abstract class LoginViewModelInputs{
  setUsreName(String userName);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputAreAllValid;
}

abstract class LoginViewModelOutpus{
  Stream<bool> get outIsUserNameVaild;
  Stream<bool> get outIsPasswordVaild;
  Stream<bool> get outAreAllValid;
}