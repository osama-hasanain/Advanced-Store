import 'package:advanced_flutter/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

final LoginViewModel _viewModel = LoginViewModel(_loginUseCase);
final TextEditingController _userNameController = TextEditingController();
final TextEditingController _userPasswordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

_bind(){
  _viewModel.start(); // tell viewModel. startut job
  _userNameController.addListener(()=>
    _viewModel.setUsreName(_userNameController.text)
  );
  _userPasswordController.addListener(()=>
    _viewModel.setUsreName(_userPasswordController.text)
  );
}

@override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _getContentWidget(){
    return Scaffold(
      body:  Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),
        color:  ColorManager.white,
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
                      );
                    }),
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
