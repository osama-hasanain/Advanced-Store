import 'package:advanced_flutter/app/constants.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class FlowState{
  StateRendererType getStateRenderType();
  String getMessage();
}

//loading state (POPUP,FULL SCREEN)
class LoadingState extends FlowState{
  StateRendererType stateRendererType;
  String? message;

  LoadingState({required this.stateRendererType,String message = AppStrings.loading});

  @override
  String getMessage() => message ?? AppStrings.loading.tr();

  @override
  StateRendererType getStateRenderType() => stateRendererType;

}

//error state (POPUP,FULL SCREEN)
class ErrorState extends FlowState{
  StateRendererType stateRendererType;
  String message;

  ErrorState({required this.stateRendererType,required this.message});

  @override
  String getMessage() => message ;

  @override
  StateRendererType getStateRenderType() => stateRendererType;

}

//content state (POPUP,FULL SCREEN)
class ContentState extends FlowState{
  ContentState();

  @override
  String getMessage() => Constants.empty ;

  @override
  StateRendererType getStateRenderType() => StateRendererType.contentState;

}

//success state (POPUP,FULL SCREEN)
class SuccessState extends FlowState{
 StateRendererType stateRendererType;
  String message;

  SuccessState({required this.stateRendererType,required this.message});

  @override
  String getMessage() => message ;

  @override
  StateRendererType getStateRenderType() => stateRendererType;

}

//empty state (POPUP,FULL SCREEN)
class EmptyState extends FlowState{
  String message;
  EmptyState(this.message);

  @override
  String getMessage() => Constants.empty ;

  @override
  StateRendererType getStateRenderType() => StateRendererType.fullScreenEmptyState;

}

extension FlowSateExtension on FlowState{
  Widget getScreenWidget(BuildContext context,Widget contentScreenWidget,Function retryActionFunction){
    switch(runtimeType){
      case LoadingState:
        {
          dismissDialog(context);
          if(getStateRenderType() == StateRendererType.popupLoadingState)
            {
              //show popup loading
              showPopup(
                context,
                getStateRenderType(),
                getMessage()
              );
              //show content ui of the screen
              return contentScreenWidget;
            }
          else
            {
              //full screen loading state
              return StateRenderer(
                message: getMessage(),
                stateRendererType: getStateRenderType(),
                retryActionFunction: retryActionFunction,
              );
            }   
        }
      case ErrorState:
        {
          dismissDialog(context);
          if(getStateRenderType() == StateRendererType.popupErrorState)
            {
              //show popup error
              showPopup(
                context,
                getStateRenderType(),
                getMessage()
              );
              //show content ui of the screen
              return contentScreenWidget;
            }
          else
            {
              //full screen error state
              return StateRenderer(
                message: getMessage(),
                stateRendererType: getStateRenderType(),
                retryActionFunction: retryActionFunction,
              );
            }  
        }
      case EmptyState:
        {
          return StateRenderer(
            stateRendererType: getStateRenderType(),
            message: getMessage(),
            retryActionFunction: (){}
           );
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
       case SuccessState:
        {   
            dismissDialog(context);
            //show popup success
            showPopup(
              context,
              getStateRenderType(),
              getMessage()
            );
            //show success ui of the screen
            return contentScreenWidget;
            
        } 
      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  } 

  _isCurrentDialogShowing(BuildContext context) =>
   ModalRoute.of(context)?.isCurrent != true;

   dismissDialog(BuildContext context){
    if(_isCurrentDialogShowing(context)){
      Navigator.of(context,rootNavigator: true).pop();
    }
   }

  showPopup(BuildContext context,StateRendererType stateRendererType,String message){
    WidgetsBinding.instance.addPostFrameCallback((_) =>
      showDialog(
        context: context,
        builder: (BuildContext context) => 
          StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            retryActionFunction: (){}
          )
      )
    );
  }
}