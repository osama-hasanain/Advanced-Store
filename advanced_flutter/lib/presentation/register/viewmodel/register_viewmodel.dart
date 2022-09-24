import 'dart:async';
import 'dart:io';

import 'package:advanced_flutter/domain/usecase/register_usecase.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/common/freezed_data_classes.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';

class RegisterViewModel extends BaseViewModel with RegisterViewModelnput,RegisterViewModelOutput{

  StreamController userNameStreamController = StreamController<String>.broadcast();
  StreamController mobileNumberStreamController = StreamController<String>.broadcast();
  StreamController emailStreamController = StreamController<String>.broadcast();
  StreamController passwordStreamController = StreamController<String>.broadcast();
  StreamController profilePictureStreamController = StreamController<File>.broadcast();
  StreamController areAllInputsValidStreamController = StreamController<void>.broadcast();
  final StreamController isUserRegisteredSuccessfullyStreamController = StreamController<bool>();

  RegisterUseCase _registerUseCase;
  var registerObject = RegisterObject('','','','','','');

  RegisterViewModel(this._registerUseCase);

  //inputs

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    userNameStreamController.close();
    mobileNumberStreamController.close();
    emailStreamController.close();
    passwordStreamController.close();
    profilePictureStreamController.close();
    areAllInputsValidStreamController.close();
    isUserRegisteredSuccessfullyStreamController.close();
    super.dispose();
  }
  
  @override
  Sink get inputEmail => emailStreamController.sink;
  
  @override
  Sink get inputMobileNumber => mobileNumberStreamController.sink;
  
  @override
  Sink get inputPassword => passwordStreamController.sink;
  
  @override
  Sink get inputProfilepicture => profilePictureStreamController.sink;
  
  @override
  Sink get inputUserName =>  userNameStreamController.sink;

  @override
  Sink get inputAllInputsValid => areAllInputsValidStreamController.sink;
 
 @override
  register() async{
   inputState.add(
    LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    //fold from Either to return LEFT and RIGHT
    (await _registerUseCase.execute( 
      RegisterUseCaseInput(
        registerObject.userName,
        registerObject.countryMobileCode,
        registerObject.mobileNumber,
        registerObject.email,
        registerObject.password,
        '',
      )))
      .fold((failure) => {
        // left -> (failure)
         inputState.add(ErrorState(stateRendererType: StateRendererType.popupErrorState,message: failure.message))
      }, (data)  {
        // right -> (success)
        inputState.add(ContentState());
        isUserRegisteredSuccessfullyStreamController.add(true);
        //navigate to main screen
       // isUserLoggedInSuccessfullyStreamController.add(true);
      });
  }

   @override
  setUserName(String userName) {
    inputUserName.add(userName);
   if(_isUserNameValid(userName)){
      //update register view object
      registerObject = registerObject.copyWith(userName: userName);
    }else{
      // reset userName value in register voiw object
      registerObject = registerObject.copyWith(userName: '');
    }
    validate();
  }
 
 

  @override
  setCountryCode(String countryCode) {
   if(countryCode.isNotEmpty){
      //update register view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    }else{
      // reset countryCode value in register voiw object
      registerObject = registerObject.copyWith(countryMobileCode: '');
    }
    validate();
  }
  
  @override
  setEmail(String email) {
    inputEmail.add(email);
    if(_isEmailValid(email)){
      //update register view object
      registerObject = registerObject.copyWith(email: email);
    }else{
      // reset email value in register voiw object
      registerObject = registerObject.copyWith(email: '');
    }
    validate();
  }
  
  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
     if(_isMobileNumber(mobileNumber)){
      //update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    }else{
      // reset mobileNumber value in register voiw object
      registerObject = registerObject.copyWith(mobileNumber: '');
    }
    validate();
  }
  
  @override
  setPassword(String password) {
    inputPassword.add(password);
     if(_isPasswordValid(password)){
      //update register view object
      registerObject = registerObject.copyWith(password: password);
    }else{
      // reset password value in register voiw object
      registerObject = registerObject.copyWith(password: '');
    }
    validate();
  }
  
  @override
  setProfilePicture(File profilePicture) {
    inputProfilepicture.add(profilePicture);
     if(profilePicture.path.isNotEmpty){
      //update register view object
      registerObject = registerObject.copyWith(profilePicture: profilePicture.path);
    }else{
      // reset profilePicture value in register voiw object
      registerObject = registerObject.copyWith(profilePicture: '');
    }
    validate();
  }
  
 

  
  //outputs
  @override
  Stream<bool> get outputIsUserNameValid => userNameStreamController.stream.map((userName) => 
  _isUserNameValid(userName));

   @override
  Stream<String?> get outputErrorUserName => 
  outputIsUserNameValid.map((isUserName) =>  isUserName ? null : AppStrings.userNameInvaild );

  @override
  Stream<bool> get outputIsEmailValid =>
   emailStreamController.stream.map((email) => _isEmailValid(email));
  
  @override
  Stream<String?> get outputErrorEmail =>
  outputIsEmailValid.map((isEmailValid) =>  isEmailValid ? null : AppStrings.emailInvaild );
  
  @override
  Stream<bool> get outputIsMobileNumberValid => 
   mobileNumberStreamController.stream.map((mobileNumber) => _isMobileNumber(mobileNumber));
  
  @override
  Stream<String?> get outputErrorMobileNumber => 
  outputIsMobileNumberValid.map((isMobileNumberValid) =>  
  isMobileNumberValid ? null : AppStrings.mobileNumberInvaild );
  
   @override
  Stream<bool> get outputIsPasswordValid => 
  passwordStreamController.stream.map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword =>
  outputIsPasswordValid.map((isPasswordValid) =>  
  isPasswordValid ? null : AppStrings.passwordInvaild );
  
  @override
  Stream<File> get outputProfilePictureValid => 
  profilePictureStreamController.stream.map((file) => file);
   
  @override
  Stream<bool> get outputAreAllInputsValid => 
    areAllInputsValidStreamController.stream.map((_) => _areAllInputsValid());
  
  //privte functions
   bool _isUserNameValid(String userName){
    return userName.length >= 8;
  }
  
  bool _isEmailValid(String email){
    return email.contains('@gmail.com');

  }

  bool _isMobileNumber(String mobileNumber){
    return mobileNumber.length >= 10;
  }
  
  bool _isPasswordValid(String password){
    return password.length >= 6;
  }

  bool _areAllInputsValid(){
    return 
      registerObject.countryMobileCode.isNotEmpty &&
      registerObject.mobileNumber.isNotEmpty &&
      registerObject.userName.isNotEmpty &&
      registerObject.email.isNotEmpty &&
      registerObject.password.isNotEmpty &&
      registerObject.profilePicture.isNotEmpty ;
  }
  
  validate(){
   inputAllInputsValid.add(null);
  }
  
}

abstract class RegisterViewModelnput{
  Sink get inputUserName;
  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilepicture;
  Sink get inputAllInputsValid;

  register();
  setUserName(String userName);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutput{
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;
  
  Stream<File> get outputProfilePictureValid;
  Stream<bool> get outputAreAllInputsValid;
}