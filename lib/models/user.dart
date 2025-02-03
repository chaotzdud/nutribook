import 'package:release/utils/map_convertion.dart';

class User implements MapConvertion {
  final String name;
  final String photo;
  final String birthDate;

  User({
    required this.name,
    required this.photo,
    required this.birthDate,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photo': photo,
      'birthDate': birthDate,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      photo: map['photo'] as String,
      birthDate: map['birthDate'] as String,
    );
  }
}
