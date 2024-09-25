

class User {
  int? id;
  String?name;
  String? qualification;
  int? age;
  int? phone;
  String? description;
  String? imagePath;

  User(
      this.name,
      this.qualification,
      this.age,
      this.phone,
      this.description, [
        this.imagePath,
      ]);
//named constructor
  User.withId(
      this.id,
      this.name,
      this.qualification,
      this.age,
      this.phone,
      this.description, [
        this.imagePath,
      ]);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'qualification': qualification,
      'age': age,
      'phone': phone,
      'description': description,
      'imagePath': imagePath,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  User.fromMapObject(Map<String, dynamic> map) {
    // map id key value assign to id
    id = map['id'];
    name = map['name'];
    qualification = map['qualification'];
    age = map['age'];
    phone = map['phone'];
    description = map['description'];
    imagePath = map['imagePath'];
  }
}
