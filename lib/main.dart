import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/UI/pokedex_home.dart';

void main (){
  runApp(PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});


  @override
  Widget build (BuildContext context){
    return MaterialApp(
      title: "Flutter Pokedex",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: PokedexHome(),
    );
  }
}