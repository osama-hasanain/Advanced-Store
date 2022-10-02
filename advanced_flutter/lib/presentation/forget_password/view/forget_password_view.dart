import 'package:advanced_flutter/app/di.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:advanced_flutter/presentation/forget_password/viewmodel/forget_password_viewmodel.dart';
import 'package:advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  _ForgetPasswordViewState createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {

  final ForgetPasswordViewModel _viewModel = instance<ForgetPasswordViewModel>();

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind(){
    _viewModel.start(); // tell viewModel. startut job
    _emailController.addListener(()=>
      _viewModel.setEmail(_emailController.text)
    );
    
    
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
            _viewModel.forgetPassword();
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
                    stream: _viewModel.outIsEmailVaild,
                    builder: ((context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller:  _emailController,
                        decoration: InputDecoration(
                          hintText: AppStrings.email.tr(),
                          labelText: AppStrings.email.tr(),
                          errorText: (snapshot.data ?? true) ?
                               null :
                               AppStrings.emailnameError.tr()
                        )
                      );
                    }),
                  ),
                ),              
                const SizedBox(height: AppSize.s28,),
                Padding(
                  padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outIsAllInputsVaild,
                    builder: ((context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false) ?(){
                            _viewModel.forgetPassword();
                          }:null,
                          child: const Text(
                            AppStrings.send
                          ).tr()
                          ),
                      );
                    }),
                  ),
                ),
              
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
