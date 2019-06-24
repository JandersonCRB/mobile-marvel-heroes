import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mobile_marvel_heroes/models/Hero.dart';
import 'package:mobile_marvel_heroes/models/Comic.dart';

class HeroDetail extends StatelessWidget {
  final int id;
  HeroDetail({Key key, this.id}) : super(key: key);

  Future<HeroModel> fetchHero() async {
    var response = await http.get(
        'https://gateway.marvel.com:443/v1/public/characters/$id?apikey=c5389db0d89e848d8cef484407cee443&ts=1&hash=d280bca787579a4920cc9139d06744e7');
    Map data = json.decode(response.body);
    return HeroModel.fromJson(data['data']['results'][0]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchHero(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          HeroModel hero = snapshot.data;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(hero.name),
                bottom: TabBar(
                  tabs: [
                    Tab(text: "Visão geral"),
                    Tab(text: "Quadrinhos"),
                  ],
                ),
              ),
              body: Container(
                child: TabBarView(
                  children: [
                    Overview(hero: hero),
                    ComicList(comics: hero.comics,),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class Overview extends StatelessWidget {
  final HeroModel hero;
  Overview({Key key, this.hero});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Image.network(hero.imageUrl),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "ID:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(" ${hero.id}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Descrição: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                      child: Text(hero.description == ''
                          ? 'Descrição indisponível'
                          : hero.description)),
                ],
              ),
            ),
          ],
        ));
  }
}

class ComicList extends StatelessWidget {
  final List<Comic> comics;
  const ComicList({Key key, this.comics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: comics.length,
          itemBuilder: (context, index) {
            return Text(comics[index].name);
          },
        ),
      ),
    );
  }
}