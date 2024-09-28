class User {
  String? id; // Change id to String for Firestore compatibility
  String? name;
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

  // Named constructor with an ID (useful when fetching data from Firestore)
  User.withId(
      this.id,
      this.name,
      this.qualification,
      this.age,
      this.phone,
      this.description, [
        this.imagePath,
      ]);

  // Convert a User object into a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'qualification': qualification,
      'age': age,
      'phone': phone,
      'description': description,
      'imagePath': imagePath,
    };
    // Firestore will automatically create an ID if it's not provided.
  }

  // Create a User object from a Firestore document snapshot
  factory User.fromFirestore(Map<String, dynamic> map, [String? id]) {
    return User.withId(
      id,  // The document ID from Firestore
      map['name'],
      map['qualification'],
      map['age'],
      map['phone'],
      map['description'],
      map['imagePath'],
    );
  }

  // Convert a User object to a Map for local storage (SQLite, SharedPreferences, etc.)
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

  // Create a User object from a local storage map (SQLite, SharedPreferences, etc.)
  User.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    qualification = map['qualification'];
    age = map['age'];
    phone = map['phone'];
    description = map['description'];
    imagePath = map['imagePath'];
  }
}
