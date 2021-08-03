
import 'package:covid_bot/src/pages/chat.dart';
import 'package:covid_bot/src/settings_user/preferencias_usuario.dart';
import 'package:covid_bot/src/widget/menu_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  static final String routeName = 'chat';

  HomePage({ required this.title});


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina = HomePage.routeName;
    return Scaffold(
        appBar: AppBar(
          // tomamos el title del padre llamando con el widget
          title: Text(widget.title),
          backgroundColor: (prefs.genero==1)? Colors.blue:Colors.amber,
        ),
        drawer: MenuWidget(),
        body: Center(
            child: Chat()
        )
    );
  }
}
