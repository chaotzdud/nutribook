import 'package:release/utils/map_convertion.dart';

class Food implements MapConvertion {
  final String name;
  final String photo;
  final String category;
  final String type;

  Food({
    required this.name,
    required this.photo,
    required this.category,
    required this.type,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photo': photo,
      'category': category,
      'type': type,
    };
  }

  static Food fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'] as String,
      photo: map['photo'] as String,
      category: map['category'] as String,
      type: map['type'] as String,
    );
  }
}
