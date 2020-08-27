class FlyMaterial {
  final String name;
  final Map<String, String> properties;

  FlyMaterial(this.name, Map doc) : properties = _toStringStringMap(doc);

  static Map<String, String> _toStringStringMap(Map doc) {
    return doc.map((key, value) => MapEntry(key.toString(), value.toString()));
  }
}
