import 'package:advanced_flutter/app/app_prefs.dart';
import 'package:advanced_flutter/app/di.dart';
import 'package:advanced_flutter/data/data_source/local_data_source.dart';
import 'package:advanced_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_flutter/presentation/resources/language_manager.dart';
import 'package:advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppPreferences appPreferences = instance<AppPreferences>(); 
  LocalDataSource localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
      padding: const EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          leading:  Icon(Icons.language,color: ColorManager.primary,),
          title: Text(
            AppStrings.changeLanguage.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(
              isRtl()? math.pi : 0
            ),
            child: Icon(Icons.keyboard_arrow_right,color: ColorManager.primary,),
          ),
          onTap: (){
            _changeLanguage();
          },
        ),
        ListTile(
          leading:  Icon(Icons.contact_page_sharp,color: ColorManager.primary,),
          title: Text(
            AppStrings.contactUs.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing:  Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(
              isRtl()? math.pi : 0
            ),
            child: Icon(Icons.keyboard_arrow_right,color: ColorManager.primary,),
          ),
          onTap: (){
            _contactUS();
          },
        ),
        ListTile(
          leading:  Icon(Icons.mobile_screen_share,color: ColorManager.primary,),
          title: Text(
            AppStrings.inviteYourFriends.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing:  Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(
              isRtl()? math.pi : 0
            ),
            child: Icon(Icons.keyboard_arrow_right,color: ColorManager.primary,),
          ),
          onTap: (){
            _inviteFriends();
          },
        ),
        ListTile(
          leading:  Icon(Icons.logout,color: ColorManager.primary,),
          title: Text(
            AppStrings.logout.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing:   Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(
              isRtl()? math.pi : 0
            ),
            child: Icon(Icons.keyboard_arrow_right,color: ColorManager.primary,),
          ),
          onTap: (){
            _logout();
          },
        ),
      ],
    ));
  }

  bool isRtl(){
    return context.locale == ARABIC_LOCALE;
  }
  _changeLanguage(){
    appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }
  _contactUS(){
    
  }
  _inviteFriends(){
    
  }
  _logout(){
    // app prefs make 
    appPreferences.logout();
    // clear cache 
    localDataSource.clearCache();
    //naviagate to login screen
    Navigator.pushReplacementNamed(context,Routes.loginRoute);
  }
}
