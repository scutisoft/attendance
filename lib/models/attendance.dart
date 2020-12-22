class Attendance {
  final String email;
  final String attendance;
  final String name;
  final String cintime;
  final String date;
  final String late;
  final String couttime;
  final String extra;
  final String propic;
  final String designation;
  Attendance({this.email, this.attendance, this.name, this.cintime, this.date, this.late, this.couttime, this.extra, this.propic, this.designation});
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      email: json['email'],
      attendance:json['attendance'],
      name: json['name'],
      cintime:json['cintime'],
      date: json['date'],
      late:json['late'],
      extra: json['extra'],
      couttime:json['couttime'],
      propic: json['propic'],
      designation: json['designation']
    );
  }
}