
class ESUser{
  String id;
  String name;
  String email;
  String imageUrl;

  ESUser({this.id, this.name, this.email, this.imageUrl});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      "nickname" : name,
      "imageUrl" : imageUrl,
      "email" : email,
    };
    if(id != null){
      map["uid"] = id;
    }
    return map;
  }
  ESUser.fromMap(Map<String, dynamic> map){
    id = map["id"];
    name = map["name"];
    email = map["email"];
    imageUrl = map["imageUrl"];

  }
}