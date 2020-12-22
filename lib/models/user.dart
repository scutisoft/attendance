class User {
  final String email;
  final String password;
  final String name;
  final String phoneno;
  final String designation;
  final String dob;
  final String propic;
  final String level;

  User({this.email, this.password, this.name, this.phoneno, this.designation, this.dob, this.propic, this.level});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password:json['password'],
      name: json['name'],
      phoneno:json['phoneno'],
      designation: json['designation'],
      dob:json['dob'],
      propic: json['propic'],
      level:json['level'],
    );
  }
}