import 'package:advanced_flutter/data/network/app_api.dart';
import 'package:advanced_flutter/data/network/requests.dart';
import 'package:advanced_flutter/data/response/response.dart';

abstract class RemoteDataSource{
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource{

  final AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest)async {
    return await 
      _appServiceClient.login(loginRequest.email, loginRequest.password);
  }

}