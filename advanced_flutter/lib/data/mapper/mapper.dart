import 'package:advanced_flutter/app/constants.dart';
import 'package:advanced_flutter/data/response/response.dart';
import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/app/extensions.dart';

extension CustomerResponseMapper on CustomerResponse?{
  Customer toDomain(){
    return Customer(
      this?.id.orEmpty()??Constants.empty,
      this?.name.orEmpty()??Constants.empty,
      this?.numOfNofication.orZero()??Constants.zero
      );
  }
}

extension ContactsResponseMapper on ContactsResponse?{
  Contacts toDomain(){
    return Contacts(
      this?.phone.orEmpty()??Constants.empty,
      this?.email.orEmpty()??Constants.empty,
      this?.email.orEmpty()??Constants.empty
      );
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse?{
  Authentication toDomain(){
    return Authentication(
      this?.customer.toDomain(),
      this?.contacts.toDomain(),
      );
  }
}