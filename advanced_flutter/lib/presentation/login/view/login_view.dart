import 'package:advanced_flutter/app/app_prefs.dart';
import 'package:advanced_flutter/app/di.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:advanced_flutter/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

final LoginViewModel _viewModel = instance<LoginViewModel>();

final TextEditingController _userNameController = TextEditingController();
final TextEditingController _userPasswordController = TextEditingController();
final _formKey = GlobalKey<FormState>();
final AppPreferences _appPreferences = instance<AppPreferences>();


_bind(){
  _viewModel.start(); // tell viewModel. startut job
  _userNameController.addListener(()=>
    _viewModel.setUsreName(_userNameController.text)
  );
  _userPasswordController.addListener(()=>
    _viewModel.setPassword(_userPasswordController.text)
  );
  _viewModel.isUserLoggedInSuccessfullyStreamController.stream.listen((isLoggedIn) {
    if(isLoggedIn){
      // navigate to main screen
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
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context,_getContentWidget(),(){
            _viewModel.login();
          })??_getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget(){
    return Scaffold(
      backgroundColor: ColorManager.white,
      body:  Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(child: Image(image: AssetImage(ImageAssets.splashLogo)),),
                const SizedBox(height: AppSize.s28,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outIsUserNameVaild,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller:  _userNameController,
                        decoration: InputDecoration(
                          hintText: AppStrings.username,
                          labelText: AppStrings.username,
                          errorText: (snapshot.data ?? true) ?
                               null :
                               AppStrings.usernameError
                        )
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppSize.s28,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outIsPasswordVaild,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller:  _userPasswordController,
                        decoration: InputDecoration(
                          hintText: AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: (snapshot.data ?? true) ?
                               null :
                               AppStrings.passwordError
                        )
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppSize.s28,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outAreAllValid,
                    builder: ((context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false) ?(){
                            _viewModel.login();
                          }:null,
                          child: const Text(
                            AppStrings.login
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    TextButton(
                      onPressed: ()=>
                          Navigator.pushNamed(context,Routes.forgetPasswordRoute),
                      child: Text(
                        AppStrings.forgetPassword,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    TextButton(
                      onPressed: ()=>
                          Navigator.pushNamed(context,Routes.registerRoute),
                      child: Text(
                        AppStrings.registerText,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.end,
                      ),
                    ),
                   ]
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
