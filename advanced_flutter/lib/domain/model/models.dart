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