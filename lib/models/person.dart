class Person {
  final String id, uid, firstName, lastName, email;
  final String? middleName, displayImage;

  Person({
    required this.id,
    required this.uid,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    this.displayImage,
  });

  Map<String, dynamic> get toJSON => {
        "uid": uid,
        "email": email,
        "firstName": firstName,
        "middleName": middleName ?? "",
        "lastName": lastName,
        "displayImage": displayImage ?? "",
      };

  factory Person.fromJSON(dynamic jsonData) {
    return Person(
      id: jsonData["_id"] ?? jsonData["id"],
      uid: jsonData["uid"],
      firstName: jsonData["firstName"],
      middleName: jsonData["middleName"] ?? "",
      lastName: jsonData["lastName"],
      email: jsonData["email"],
      displayImage: jsonData["displayImage"] ?? "",
    );
  }
}
