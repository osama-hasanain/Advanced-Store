import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

@JsonSerializable()
class BaseResponse{
  @JsonKey(name: 'status')
  int? status;
  @JsonKey(name: 'message')
  String? message;
}

// This code to defualt JSON File 'flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs'
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