import 'package:advanced_flutter/app/constants.dart';
import 'package:advanced_flutter/app/di.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:advanced_flutter/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {

  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.stores.tr()+ ' ' + AppStrings.details.tr()
        ),
      ),
      body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.start();
              }) ??
              _getContentWidget();
        }),
    ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<StoreDetailsObject>(
      stream: _viewModel.outputHomeData,
      builder: (context,snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStoreImage(snapshot.data?.image),
            _getSection(AppStrings.details.tr()),
            _getParagraph(snapshot.data?.details),
            _getSection(AppStrings.services.tr()),
            _getParagraph(snapshot.data?.services),
            _getSection(AppStrings.aboutStore.tr()),
            _getParagraph(snapshot.data?.about),
          ],
        );
      }
    );
  }
  Widget _getStoreImage(String? image){
      return 
      image != null?
      Image.network(
          image,
          width: double.infinity,  
          height: AppSize.s190,
          fit: BoxFit.cover,
        ):const SizedBox();
  }

    Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p12,
        left: AppPadding.p12,
        right: AppPadding.p12,
        bottom: AppPadding.p2,
      ),
      child: Text(title, style: Theme.of(context).textTheme.labelSmall),
    );
  }
    Widget _getParagraph(String? title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p12,
        left: AppPadding.p12,
        right: AppPadding.p12,
        bottom: AppPadding.p2,
      ),
      child: Text(title??Constants.empty, style: Theme.of(context).textTheme.bodyText2),
    );
  }

   @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
