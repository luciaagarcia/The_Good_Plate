import 'package:flutter/material.dart';
import 'package:the_good_plate/rutas/login.dart';
import 'package:the_good_plate/rutas/perfil.dart';

void main() {
  runApp(
    new MaterialApp(
      home: new LoginActivity(),
      title: "The Good Plate",
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[700],
        backgroundColor: Colors.grey[800],
        canvasColor: Colors.grey[800],
        accentColor: Color.fromRGBO(36, 167, 200, 100), //azul
        //Rojo: Color.fromRGBO(200,69,36,100),
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginActivity(),
        '/perfil': (BuildContext context) => new PerfilActivity(),
      },
    ),
  );
}
