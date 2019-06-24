import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mobile_marvel_heroes/models/Hero.dart';
import 'package:mobile_marvel_heroes/screens/HeroDetail/HeroDetail.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Marvel Heroes')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: HeroList(),
      ),
    );
  }
}

class HeroList extends StatefulWidget {
  @override
  HeroListState createState() => new HeroListState();
}

class HeroListState extends State<HeroList> {
  List<HeroModel> heroes = [];
  bool loading = true;
  int offset = 0;
  ScrollController _controller;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        getData();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getData();
  }

  Future<List<HeroModel>> getData() async {
    var response = await http.get(
        Uri.encodeFull(
            'https://gateway.marvel.com:443/v1/public/characters?offset=$offset&apikey=c5389db0d89e848d8cef484407cee443&ts=1&hash=d280bca787579a4920cc9139d06744e7'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        });
    Map data = json.decode(response.body);
    List<dynamic> results = data['data']['results'];
    List<HeroModel> heroes =
        results.map((model) => HeroModel.fromJson(model)).toList();
    setState(() {
      this.heroes = List.from(this.heroes)..addAll(heroes);
      this.loading = false;
      this.offset = this.offset + 20;
    });
    return heroes;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return GridView.builder(
      controller: _controller,
      itemBuilder: (BuildContext context, int i) {
        return HeroItem(hero: heroes[i]);
      },
      itemCount: heroes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.85),
    );
  }
}

class HeroItem extends StatelessWidget {
  final HeroModel hero;
  HeroItem({Key key, this.hero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HeroDetail(id: hero.id)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(7),
        child: Column(
          children: <Widget>[
            Container(
              height: 30.0,
              color: Colors.red,
              child: Center(
                child: Text(
                  hero.name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Image.network(
                hero.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}