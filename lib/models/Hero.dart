import 'package:mobile_marvel_heroes/models/Comic.dart';

class HeroModel {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Comic> comics;

  HeroModel({this.id, this.name, this.imageUrl, this.description, this.comics});

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> comicItems = json['comics']['items'];
    return HeroModel(
      id: json['id'],
      name: json['name'],
      imageUrl:
          json['thumbnail']['path'] + '.' + json['thumbnail']['extension'],
      description: json['description'],
      comics: comicItems.map((comic) => Comic.fromJson(comic)).toList(),
    );
  }
}
