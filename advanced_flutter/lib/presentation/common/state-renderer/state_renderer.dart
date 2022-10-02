import 'package:advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_flutter/presentation/resources/font_manager.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter/presentation/resources/style_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StateRendererType{
  //POPUP STATES (DIALOG)
  popupLoadingState,
  popupErrorState,

  //FULL SCREEN STATED (FULL SCREEN)
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
  
  //POPUP SCREEN
  popupSuccessScreenState,
  
  // GENRAL
  contentState,
}


class StateRenderer extends StatelessWidget{

  StateRendererType stateRendererType;
  String message,title;
  Function retryActionFunction;

  StateRenderer({
    required this.stateRendererType,
    this.message = AppStrings.loading,
    this.title = '',
    required this.retryActionFunction
    });

  @override
  Widget build(BuildContext context) {
    return _returnStateWidget(context);
  }

  Widget _returnStateWidget(BuildContext context){
    switch(stateRendererType){
      
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(context,[_getAnimatedImage(JsonAssets.loading)]); 
      case StateRendererType.popupErrorState:
        return _getPopupDialog(context,[ 
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.ok.tr(),context)
          ]); 
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message)
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retryAgain.tr(),context)
        ]);
      case StateRendererType.fullScreenEmptyState :
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message)
        ]);
      case StateRendererType.contentState:
        return Container();
      case StateRendererType.popupSuccessScreenState: 
        return _getPopupDialog(context,[
           _getAnimatedImage(JsonAssets.success),
          _getMessage(message),
          _getRetryButton(AppStrings.ok.tr(),context)
        ]);
      default:
        return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context,List<Widget> children){
    return Dialog(
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14)
      ),
      elevation:  AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow:const  [BoxShadow(
            color: Colors.black26
          )]
        ),
        child: _getDialogContent(context,children),
      ),
    );
  }

Widget _getDialogContent(BuildContext context,List<Widget> children) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: children,
  );
}

  Widget _getItemsColumn(List<Widget> children){
   return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animateName){
    return SizedBox(
      height: 100,
      width: 100,
      child: Lottie.asset(animateName)
    );
  }

  Widget _getMessage(String message){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          style: getRegularStyle(color: ColorManager.black,fontSize: FontSize.s18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle,BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p18),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: (){
          if(stateRendererType == StateRendererType.fullScreenErrorState){
            // call retry function
            retryActionFunction.call();
          }else{ // popup error state
          Navigator.of(context).pop();
          }
        }, child: Text(buttonTitle))),
    );
  }
}