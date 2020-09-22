class FlyFormMaterial {
  final String name;
  final Map<String, List<String>> properties;

  FlyFormMaterial(this.name, Map doc)
      : this.properties = toMapOfLists(doc[name]);

  static Map<String, List<String>> toMapOfLists(Map<dynamic, dynamic> untyped) {
    // Following the strucutre in our db, key is a String and value is an array.
    return untyped.map((key, value) {
      return MapEntry<String, List<String>>(
          key.toString(), List<String>.from(value));
    });
  }
}
