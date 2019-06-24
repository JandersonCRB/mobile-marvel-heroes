class Comic {
  final String name;

  Comic({this.name});

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      name: json['name'],
    );
  }
}
