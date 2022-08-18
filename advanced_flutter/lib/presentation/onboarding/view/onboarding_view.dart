import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/presentation/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_flutter/presentation/resources/constants_manager.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/routes_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {

  final PageController _pageController = PageController();
  OnBoardingViewModel _viewModel = OnBoardingViewModel();

  _bind(){
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream:_viewModel.outputSliderViewObject,
        builder: (context,snapshot)=>
            _getContentWidget(snapshot.data)
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject)=>
    sliderViewObject==null?
      Container():
      Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorManager.white,
              statusBarBrightness: Brightness.dark
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: sliderViewObject.numOfSlides,
          onPageChanged: (index){
              _viewModel.onPageChanged(index);
          },
          itemBuilder: (context,index)=>
              OnBoardingPage(sliderViewObject.sliderObject),
        ),
        bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: ()=>
                      Navigator.pushReplacementNamed(context,Routes.loginRoute),
                  child: Text(
                    AppStrings.skip,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              _getBottomSheetWidget(sliderViewObject)
            ],
          ),
        ),
      );


  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject)=>
      Container(
        color: ColorManager.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.p14),
              child: GestureDetector(
                onTap: (){
                  _pageController.animateToPage(
                      _viewModel.goPrevious(),
                      duration: const Duration(
                          microseconds: AppConstants.sliderAnimation
                      ),
                      curve: Curves.bounceInOut
                  );
                },
                child: SizedBox(
                  width: AppSize.s20,
                  height: AppSize.s20,
                  child: SvgPicture.asset(ImageAssets.leftCircleIc),
                ),
              ),
            ),

            Row(
              children: [
                for(int i=0;i<sliderViewObject.numOfSlides;i++)
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    child: getProperCircle(i,sliderViewObject.currentIndex),
                  )
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(AppPadding.p14),
              child: GestureDetector(
                onTap: (){
                  _pageController.animateToPage(
                      _viewModel.goNext(),
                      duration: const Duration(
                          microseconds: AppConstants.sliderAnimation
                      ),
                      curve: Curves.bounceInOut
                  );
                },
                child: SizedBox(
                  width: AppSize.s20,
                  height: AppSize.s20,
                  child: SvgPicture.asset(ImageAssets.rightCircleIc),
                ),
              ),
            )
          ],
        ),
      );


  Widget getProperCircle(int index,int currentIndex){
    if(index==currentIndex)
      return SvgPicture.asset(ImageAssets.hollowSolidIc);
    else
      return SvgPicture.asset(ImageAssets.solidSolidIc);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;
  const OnBoardingPage(this._sliderObject,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: AppSize.s40),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
              _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(height: AppSize.s60,),
        SvgPicture.asset(_sliderObject.image)
      ],
    );
  }
}

