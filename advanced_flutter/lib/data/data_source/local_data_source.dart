import 'package:advanced_flutter/data/network/error_handler.dart';
import 'package:advanced_flutter/data/response/response.dart';

const   CACHE_HOME_KEY = 'CASHE_HOME_KEY';
const   CACHE_HOME_INTERVAL = 60*100; // 1 minute cache in mills 
abstract class LocalDataSource{
  Future<HomeResponse> getHomeData();

  Future<void> saveHomeToCache(HomeResponse homeResponse);
  
  void clearCache();

  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource{
  // run time cache
  Map<String,CachedItem> cacheMap = Map();

  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];

    if(cachedItem!=null && cachedItem.isValid(CACHE_HOME_INTERVAL)){
      // return the response from cache
      return cachedItem.data;
    }else{
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }

  }
  
  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }
  
  @override
  void clearCache() {
    cacheMap.clear();
  }
  
  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

}

class CachedItem{
  dynamic data;

  int cacheTime = DateTime.now().microsecondsSinceEpoch;

  CachedItem(this.data);
}

extension CashedItemExtension on CachedItem{
  bool isValid(int expirationTimeInMillis){
  
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;

    bool isValid = currentTimeInMillis - cacheTime <= expirationTimeInMillis;

    return isValid;

  }
}