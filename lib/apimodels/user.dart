enum EUserType {
  ADMIN,
  USER,
}

class User {
  String name;
  String company;
  String token;
  EUserType type;

  User(this.name, this.company, this.token, this.type);

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    company = json['company'];
    token = json['token'];
    type = EUserType.values[json['type']];
  }
}
