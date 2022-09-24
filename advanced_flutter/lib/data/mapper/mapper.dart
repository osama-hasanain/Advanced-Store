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

extension ForgetPaswordResponseMapper on ForgetPasswordResponse?{
  String toDomain(){
    return this?.support?.orEmpty()?? Constants.empty;
  }
}

extension ServiceResponseMapper on ServiceResponse?{
  Service toDomain(){
    return Service(
      this?.id??Constants.zero,
      this?.title??Constants.empty,
      this?.image??Constants.empty,
    );
  }
}

extension BannerResponseMapper on BannerResponse?{
  BannerAd toDomain(){
    return BannerAd(
      this?.id??Constants.zero,
      this?.title??Constants.empty,
      this?.image??Constants.empty,
      this?.link??Constants.empty,
    );
  }
}

extension StoreResponseMapper on StoreResponse?{
  Store toDomain(){
    return Store(
      this?.id??Constants.zero,
      this?.title??Constants.empty,
      this?.image??Constants.empty,
    );
  }
}

extension HomeResponseMapper on HomeResponse?{
  HomeObject toDomain(){

    List<Service> services = (this?.data?.services?.map((serviceResponse) =>
       serviceResponse.toDomain())?? const Iterable.empty()).cast<Service>().toList();

    List<BannerAd> banners = (this?.data?.banners?.map((bannersResponse) =>
       bannersResponse.toDomain())?? const Iterable.empty()).cast<BannerAd>().toList();
       
    List<Store> stores = (this?.data?.stores?.map((storesResponse) =>
       storesResponse.toDomain())?? const Iterable.empty()).cast<Store>().toList();


    var data = HomeData(services, banners, stores);
    return HomeObject(data);
  }
}