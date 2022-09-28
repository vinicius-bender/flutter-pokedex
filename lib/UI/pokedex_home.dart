// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokedex/UI/pokemon_page.dart';

class PokedexHome extends StatefulWidget{
  const PokedexHome({super.key});

  @override
  PokedexHomeState createState ()=> PokedexHomeState();
}

class PokedexHomeState extends State<PokedexHome>{
  
  String search = "";
  List<Map<String, dynamic>> pokemons = [];

    @override
    void initState() {
    super.initState();
    getData().then((map){
      //debugPrint(map.toString());
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Pokedex"),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  Padding(
            //   padding:  EdgeInsets.fromLTRB(12, 12, 12, 0),
            //   child: TextField(
            //     style: TextStyle(color: Colors.white),
            //      decoration: InputDecoration(
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(width: 2, color: Colors.white),
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: BorderSide(width: 2, color: Colors.white),
            //       ),
            //       labelText: "Pokemon Name",
            //       labelStyle: TextStyle(
            //         color: Colors.white,
            //       ),
            //      ),
            //      onChanged: (text){
            //         setState(() {
            //           search = text;
            //         });
            //      },
            //   ),
            // ),
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
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
                      if (snapshot.hasError){
                        return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                      }else{
                        return createPokemonCards(context, snapshot);
                      }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getData () async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50');
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  int getCount (List data){
      return data.length;
  }

  Widget createPokemonCards (BuildContext context, AsyncSnapshot snapshot){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: getCount(snapshot.data["results"]), 
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                   child: Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${index+1}.png",
                   fit: BoxFit.cover,
                   height: 100.0,
                   width: 100,
                    ),
                  ),
                  Text(snapshot.data["results"][index]["name"], style: TextStyle(color: Colors.white, fontSize: 22.0),),
                ],
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PokemonPage(snapshot.data["results"][index], index)));
            }
          );
          // return Container(
          //   decoration: BoxDecoration(
          //     color: Colors.grey,
          //     border: Border.all(color: Colors.white, width: 2),
          //   ),
          //   width: 200,
          //   height: 200,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${index+1}.png",
          //       fit: BoxFit.cover,
          //       height: 100.0,
          //       ),
          //       SizedBox(
          //         height: 20.0,
          //       ),
          //       Text(snapshot.data["results"][index]["name"], style: TextStyle(color: Colors.white),),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }
}