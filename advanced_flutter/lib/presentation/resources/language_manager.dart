import 'package:flutter/cupertino.dart';

enum LanguageType{
  ENGLISH,ARABIC
}

const String ARABIC = 'ar';
const String ENGLISH = 'en';
const String ASSET_PATH_LOCALIZATIONS = 'assets/translations';

const Locale ARABIC_LOCALE = Locale('ar','SA');
const Locale ENGLISH_LOCALE = Locale('en','US');

extension LanguageTypeEtension on LanguageType{
  String getValue(){
    switch(this){
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
    }
  }
}