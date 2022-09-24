import 'dart:io';

import 'package:advanced_flutter/app/app_prefs.dart';
import 'package:advanced_flutter/app/constants.dart';
import 'package:advanced_flutter/app/di.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:advanced_flutter/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _mobileNumberEditingController = TextEditingController();

  _bind(){
    _viewModel.start();
    _viewModel.setCountryCode('+970');
    _userNameEditingController.addListener(() { 
      _viewModel.setUserName(_userNameEditingController.text);
    });
    _emailEditingController.addListener(() { 
      _viewModel.setEmail(_emailEditingController.text);
    });
    _passwordEditingController.addListener(() { 
      _viewModel.setPassword(_passwordEditingController.text);
    });
    _mobileNumberEditingController.addListener(() { 
      _viewModel.setMobileNumber(_mobileNumberEditingController.text);
    });
    _viewModel.isUserRegisteredSuccessfullyStreamController.stream.listen((isLoggedIn) {
      if(isLoggedIn){
        //navigate to main screen
        SchedulerBinding.instance.addPersistentFrameCallback((_) { 
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    }); 
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(
          color: ColorManager.primary
        ),
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context,_getContentWidget(),(){
            _viewModel.register();
          })??_getContentWidget();
        },
      ),
    );
  }

 Widget _getContentWidget(){
    return Scaffold(
      backgroundColor: ColorManager.white,
      body:  Container(
        padding: const EdgeInsets.only(top: AppPadding.p28),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(child: Image(image: AssetImage(ImageAssets.splashLogo),height: AppSize.s100,),),
                const SizedBox(height: AppSize.s28,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorUserName,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.name,
                        controller:  _userNameEditingController,
                        decoration: InputDecoration(
                          hintText: AppStrings.username,
                          labelText: AppStrings.username,
                          errorText: snapshot.data ,
                        )
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppSize.s18,),
                Center(
                  child:Padding(
                    padding: const EdgeInsets.only(
                      left: AppPadding.p28,
                      right: AppPadding.p28
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CountryCodePicker(
                            onChanged: (country){
                              // update view model with code
                              _viewModel.setCountryCode(country.dialCode?? Constants.token);
                            },
                            initialSelection: '+970',
                            favorite: const ['+970','+20','+966'],
                            showCountryOnly: true,
                            showOnlyCountryWhenClosed: true,
                            hideMainText: true,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorMobileNumber,
                          builder: ((context, snapshot) {
                            return TextFormField(
                              keyboardType: TextInputType.phone,
                              controller:  _mobileNumberEditingController,
                              decoration: InputDecoration(
                                hintText: AppStrings.mobileNumber,
                                labelText: AppStrings.mobileNumber,
                                errorText: snapshot.data
                              )
                            );
                          }),
                          )
                        ),
                      ],
                    ),
                  )
                ),
                const SizedBox(height: AppSize.s18,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorEmail,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller:  _emailEditingController,
                        decoration: InputDecoration(
                          hintText: AppStrings.email,
                          labelText: AppStrings.email,
                          errorText: snapshot.data
                        )
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppSize.s18,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorPassword,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller:  _passwordEditingController,
                        decoration: InputDecoration(
                          hintText: AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: snapshot.data
                        )
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppSize.s18,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: Container(
                    height: AppSize.s40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
                      border: Border.all(
                        color: ColorManager.grey,
                      )
                    ),
                    child: GestureDetector(
                      child: _getMediaWidget(),
                      onTap: (){
                        _showPicker(context);
                      },
                    ),
                  )
                ),
                const SizedBox(height: AppSize.s40,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputAreAllInputsValid,
                    builder: ((context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                      _viewModel.register();
                                    }
                                  : null,
                          child: const Text(
                            AppStrings.register
                          )
                          ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                    top: AppPadding.p8
                    ),
                  child: TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppStrings.alreadyHaveAccount,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.end,
                      ),
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPicker(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery),
                onTap: (){
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text(AppStrings.photoCamera),
                onTap: (){
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      });
  }

  _imageFromGallery()async{
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ''));
  }

  _imageFromCamera()async{
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ''));
  }

  Widget _getMediaWidget(){
    return Padding(
      padding:const EdgeInsets.only(left: AppPadding.p8,right: AppPadding.p8,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(child: Text(AppStrings.profilePicture)),
          Flexible(
            child: StreamBuilder<File>(
              stream: _viewModel.outputProfilePictureValid,
              builder: (context, snapshot) {
                return _imagePicketByUser(snapshot.data);
            },
          )),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc))
        ],
      ),
    );
  }

  Widget _imagePicketByUser(File? image){
    if(image !=null && image.path.isNotEmpty){
      // return image
      return  Image.file(image);
    }else{
      return Container();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
