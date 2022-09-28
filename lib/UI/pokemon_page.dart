import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonPage extends StatelessWidget {
  PokemonPage(this.pokemonData, this.index, {super.key});

  Map<String, dynamic> pokemonData = Map<String, dynamic>();
  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Pokedex"),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
            child: Text(
              "#$index",
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getStats(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5.0,
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 5.0,
                  ),
                );
              } else {
                return createPokemonStats(context, snapshot);
              }
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getStats() async {
    var url =
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemonData["name"]}');
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Widget createPokemonStats(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent, width: 3),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            color: Colors.greenAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 26),
            child: Image.network(
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${index + 1}.png",
              width: MediaQuery.of(context).size.width,
              height: 150.0,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "${pokemonData["name"]}",
          style: const TextStyle(color: Colors.white, fontSize: 26.0),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Colors.red),
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "${snapshot.data["types"][0]["type"]["name"]}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 35.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${snapshot.data["weight"]/10} kg",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              //width: 70.0,
            ),
            Text(
              "${snapshot.data["height"]/10} m",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              "weight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              //width: 70.0,
              height: 50.0,
            ),
            Text(
              "height",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
