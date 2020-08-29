class FlyMaterial {
  final String name;
  final Map<String, String> properties;

  FlyMaterial({this.name, Map props}) : properties = _toStringStringMap(props);

  static Map<String, String> _toStringStringMap(Map props) {
    return props
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  String getProperty(String prop) {
    return properties[prop];
  }
}
