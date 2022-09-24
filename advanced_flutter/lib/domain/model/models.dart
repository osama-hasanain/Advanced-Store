//onBoarding models
class SliderObject{
  String title;
  String subTitle;
  String image;
  SliderObject(this.title,this.subTitle,this.image);
}

class SliderViewObject{
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;
  SliderViewObject(
      this.sliderObject,
      this.numOfSlides,
      this.currentIndex,
      );
}

//Login Modeles
class Customer{
  String id;
  String name;
  int numOfNofication;
  Customer(this.id,this.name,this.numOfNofication);
}

class Contacts{
  String phone;
  String email;
  String link;
  Contacts(this.phone,this.email,this.link);
}

class Authentication{
  Customer? customer;
  Contacts? contact;
  Authentication(this.customer,this.contact);
}

class Service{
  int id;
  String title,image;
  Service(this.id,this.title,this.image);
}

class Store{
  int id;
  String title,image;
  Store(this.id,this.title,this.image);
}

class BannerAd{
  int id;
  String title,image,link;
  BannerAd(this.id,this.title,this.image,this.link);
}

class HomeData{
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;
  HomeData(this.services,this.banners,this.stores);
}

class HomeObject{
  HomeData data;
  HomeObject(this.data); 
}