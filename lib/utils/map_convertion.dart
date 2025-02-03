abstract class MapConvertion {
  Map<String, dynamic> toMap();

  static T fromMap<T>(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap needs to be implemented in subclasses');
  }
}
