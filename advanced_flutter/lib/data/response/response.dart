import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

@JsonSerializable()
class BaseResponse{
  @JsonKey(name: 'status')
  int? status;
  @JsonKey(name: 'message')
  String? message;
}

// This code to defualt JSON File 'flutter pub get ; flutter pub run build_runner build --delete-conflicting-outputs'
@JsonSerializable()
class AuthenticationResponse extends BaseResponse{
  @JsonKey(name: 'customer')
  CustomerResponse? customer;
  @JsonKey(name: 'contacts')
  ContactsResponse? contacts;

  // MAIN Constructor
  AuthenticationResponse(this.customer,this.contacts);

  // FROM Json
 factory AuthenticationResponse.fromJson(Map<String,dynamic> json) =>
     _$AuthenticationResponseFromJson(json);

 // TO Json
 Map<String,dynamic> toJson() => _$AuthenticationResponseToJson(this);
}

@JsonSerializable()
class CustomerResponse{
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'numOfNofication')
  int? numOfNofication;

  // MAIN Constructor
  CustomerResponse(this.id,this.name,this.numOfNofication);

  // FROM Json
  factory CustomerResponse.fromJson(Map<String,dynamic> json) =>
      _$CustomerResponseFromJson(json);

  // TO Json
  Map<String,dynamic> toJson() => _$CustomerResponseToJson(this);
}

@JsonSerializable()
class ContactsResponse{
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'link')
  String? link;

  // MAIN Constructor
  ContactsResponse(this.phone,this.email,this.link);

  // FROM Json
  factory ContactsResponse.fromJson(Map<String,dynamic> json) =>
      _$ContactsResponseFromJson(json);

  // TO Json
  Map<String,dynamic> toJson() => _$ContactsResponseToJson(this);
}

@JsonSerializable()
class ForgetPasswordResponse extends BaseResponse{
  @JsonKey(name: 'support')
  String? support;
  
  // MAIN Constructor
  ForgetPasswordResponse(this.support);

  // FROM Json
 factory ForgetPasswordResponse.fromJson(Map<String,dynamic> json) =>
     _$ForgetPasswordResponseFromJson(json);

 // TO Json
 Map<String,dynamic> toJson() => _$ForgetPasswordResponseToJson(this);
}

@JsonSerializable()
class ServiceResponse{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? title;

  @JsonKey(name: 'image')
  String? image;

  ServiceResponse(this.id,this.title,this.image);

   // FROM Json
 factory ServiceResponse.fromJson(Map<String,dynamic> json) =>
     _$ServiceResponseFromJson(json);

 // TO Json
 Map<String,dynamic> toJson() => _$ServiceResponseToJson(this);
}

@JsonSerializable()
class BannerResponse{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? title;

  @JsonKey(name: 'image')
  String? image;

  @JsonKey(name: 'link')
  String? link;

  BannerResponse(this.id,this.title,this.image,this.link);

   // FROM Json
 factory BannerResponse.fromJson(Map<String,dynamic> json) =>
     _$BannerResponseFromJson(json);

 // TO Json
 Map<String,dynamic> toJson() => _$BannerResponseToJson(this);
}

@JsonSerializable()
class StoreResponse{
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? title;

  @JsonKey(name: 'image')
  String? image;

  @JsonKey(name: 'link')
  String? link;

  StoreResponse(this.id,this.title,this.image,this.link);

   // FROM Json
 factory StoreResponse.fromJson(Map<String,dynamic> json) =>
     _$StoreResponseFromJson(json);

 // TO Json
 Map<String,dynamic> toJson() => _$StoreResponseToJson(this);
}


@JsonSerializable()
class HomeDataResponse{
  @JsonKey(name: 'services')
  List<ServiceResponse>? services;
  
  @JsonKey(name: 'banners')
  List<BannerResponse>? banners;
  
  @JsonKey(name: 'stores')
  List<StoreResponse>? stores;

  HomeDataResponse(this.services,this.banners,this.stores);
  
   // FROM Json
  factory HomeDataResponse.fromJson(Map<String,dynamic> json) =>
     _$HomeDataResponseFromJson(json);

  // TO Json
  Map<String,dynamic> toJson() => _$HomeDataResponseToJson(this);
}

@JsonSerializable()
class HomeResponse extends BaseResponse{
  @JsonKey(name: 'data')
  HomeDataResponse? data;

   HomeResponse(this.data);
  
   // FROM Json
  factory HomeResponse.fromJson(Map<String,dynamic> json) =>
     _$HomeResponseFromJson(json);

  // TO Json
  Map<String,dynamic> toJson() => _$HomeResponseToJson(this);
  
}