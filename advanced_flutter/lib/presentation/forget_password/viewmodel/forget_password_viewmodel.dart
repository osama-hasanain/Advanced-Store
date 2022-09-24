import 'dart:async';

import 'package:advanced_flutter/domain/usecase/forget_password_usecase.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';

class ForgetPasswordViewModel extends BaseViewModel with ForgetPasswordViewModelInputs,ForgetPasswordViewModelOutpus{
  
  // broadcast() for many listen to StreamCnotroller until not face BadStateError
  final StreamController _emailStreamController = StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController = StreamController<void>.broadcast();

  var email = '';

  final ForgetPasswordUseCase _forgetPasswordUseCase ;
  ForgetPasswordViewModel(this._forgetPasswordUseCase);

  //inputs

@override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
    super.dispose();
  }
  @override
  void start() {
    // view model should tell view please show content state
    inputState.add(ContentState());
  }

  @override
  Sink get inputEmail => _emailStreamController.sink ;

   @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  forgetPassword() async{
     inputState.add(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    //fold from Either to return LEFT and RIGHT
    (await _forgetPasswordUseCase.execute(email))
      .fold((failure) => {
        // left -> (failure)
         inputState.add(ErrorState(stateRendererType: StateRendererType.popupErrorState,message: failure.message))
      }, (support)  {
        // right -> (success)
        inputState.add(SuccessState(stateRendererType: StateRendererType.popupSuccessScreenState,message: support));
      
        //navigate to main screen
      });
  }

  

  @override
  Stream<bool> get outIsEmailVaild => 
    _emailStreamController.stream.map((email) =>_isEmailValid(email));

  @override
  Stream<bool> get outIsAllInputsVaild => 
  _isAllInputValidStreamController.stream.map((email) =>_isAllInputsValid());  

   bool _isAllInputsValid(){
    return email.contains('@gmail.com');
    }
   bool _isEmailValid(String email){
    return email.isNotEmpty;
    }

   _validate(){
    _isAllInputValidStreamController.add(null);
   } 

}

abstract class ForgetPasswordViewModelInputs{
  setEmail(String email);
  
  forgetPassword();

  Sink get inputEmail;

   Sink get inputIsAllInputValid;
}

abstract class ForgetPasswordViewModelOutpus{
  Stream<bool> get outIsEmailVaild;
  Stream<bool> get outIsAllInputsVaild;
}