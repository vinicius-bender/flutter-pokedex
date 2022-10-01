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
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
            child: Text(
              "#00$index",
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
                //width: 200,
                //height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5.0,
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Container(
                  //width: 200,
                 //height: 200,
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
    int hp = snapshot.data["stats"][0]["base_stat"];
    int atk = snapshot.data["stats"][1]["base_stat"];
    int def = snapshot.data["stats"][2]["base_stat"];
    int spd = snapshot.data["stats"][5]["base_stat"];
    int exp = snapshot.data["base_experience"];
    String type = snapshot.data["types"][0]["type"]["name"];
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all( color: bgColor(type) ,width: 3),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            color: bgColor(type),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 26),
            child: Image.network(
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${index + 1}.png",
              width: MediaQuery.of(context).size.width,
              height: 120.0,
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
                color: bgColor(type),
                border: Border.all(color: bgColor(type)),
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
        const SizedBox(
          height: 15.0,
        ),
        const Text("Base Stats", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w400),),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("HP ", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 10.0,),
              Text("${hp.toString()}  ", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 18.0,),
              CustomPaint(
                size: Size(hp.toDouble(), 0.0),
                painter: HpLine(),
              ),
            ],
          ),
        ),
         Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("ATK", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 10.0,),
              Text("${atk.toString()} ", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 17.0,),
              CustomPaint(
                size: Size(atk.toDouble(), 0.0),
                painter: AtkLine(),
              ),
            ],
          ),
        ),
         Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("DEF", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 10.0,),
              Text("${def.toString()} ", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 18.0,),
              CustomPaint(
                size: Size(def.toDouble(), 0.0),
                painter: DefLine(),
              ),
            ],
          ),
        ),
         Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("SPD", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 10.0,),
              Text("${spd.toString()} ", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 18.0,),
              CustomPaint(
                size: Size(spd.toDouble(), 0.0),
                painter: SpdLine(),
              ),
            ],
          ),
               ),
         Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("EXP", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 10.0,),
              Text("${exp.toString()} ", style: TextStyle(color: Colors.grey, fontSize: 16.0),),
              SizedBox(width: 18.0,),
              CustomPaint(
                size: Size(exp.toDouble(), 0.0),
                painter: ExpLine(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color bgColor (type){
    if (type == "normal"){
      return Color(0xFFa8a8a8);
    }else if (type == "fire"){
      return Color(0xFFf08030);
    }else if (type == "water"){
      return Color.fromARGB(255, 51, 143, 230);
    }else if (type == "electric"){
      return Color(0xFFf8b00f);
    }else if (type == "grass"){
      return Color(0xFF78c851);
    }else if (type == "ice"){
      return Color(0xFF98d9d8);
    }else if (type == "fighting,"){
      return Color(0xFFe83001);
    }else if (type == "poison"){
      return Color(0xFFa040a0);
    }else if (type == "ground"){
      return Color(0xFFd8e02f);
    }else if (type == "flying"){
      return Color(0xFF9f94be);
    }else if (type == "psychic"){
      return Color(0xFFf85888);
    }else if (type == "bug"){
      return Color(0xFFa8b821);
    }else if (type == "rock"){
      return Color(0xFFb8a038);
    }else if (type == "ghost"){
      return Color(0xFF5d4674);
    }else if (type == "dragon"){
      return Color(0xFF623bd5);
    }else if (type == "dark"){
      return Color(0xFF776554);
    }else if (type == "steel"){
      return Color(0xFFb1adbb);
    }else if (type == "fairy"){
      return Color(0xFFf8b8e8);
    }else {
      return Color.fromARGB(255, 66, 66, 66);
    }
  }
}




class HpLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromARGB(255, 226, 19, 64);
    paint.strokeWidth = 15;
    paint.strokeCap = StrokeCap.round;

    Offset startingOffset = Offset(0, size.height);
    Offset endingOffset = Offset(size.width, size.height);

    canvas.drawLine(startingOffset, endingOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AtkLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromARGB(255, 226, 160, 19);
    paint.strokeWidth = 15;
    paint.strokeCap = StrokeCap.round;

    Offset startingOffset = Offset(0, size.height);
    Offset endingOffset = Offset(size.width, size.height);

    canvas.drawLine(startingOffset, endingOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DefLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromARGB(255, 0, 124, 207);
    paint.strokeWidth = 15;
    paint.strokeCap = StrokeCap.round;

    Offset startingOffset = Offset(0, size.height);
    Offset endingOffset = Offset(size.width, size.height);

    canvas.drawLine(startingOffset, endingOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SpdLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromARGB(255, 146, 146, 146);
    paint.strokeWidth = 15;
    paint.strokeCap = StrokeCap.round;

    Offset startingOffset = Offset(0, size.height);
    Offset endingOffset = Offset(size.width, size.height);

    canvas.drawLine(startingOffset, endingOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ExpLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromARGB(255, 0, 124, 6);
    paint.strokeWidth = 15;
    paint.strokeCap = StrokeCap.round;

    Offset startingOffset = Offset(0, size.height);
    Offset endingOffset = Offset(size.width, size.height);

    canvas.drawLine(startingOffset, endingOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
