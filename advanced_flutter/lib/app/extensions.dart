import 'package:advanced_flutter/app/constants.dart';

extension NonNullString on String?{
  String orEmpty(){
    if(this == null){
      return Constants.empty;
    }else{
      return this!;
    }
  }
}

extension NonNullinteger on int?{
  int orZero(){
    if(this == null){
      return Constants.zero;
    }else{
      return this!;
    }
  }
}