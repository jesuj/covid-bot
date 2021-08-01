// @dart=2.9


import 'package:covid_bot/src/pages/settings_page.dart';
import 'package:covid_bot/src/settings_user/preferencias_usuario.dart';
import 'package:covid_bot/src/widget/menu_widget.dart';
import 'package:flutter/material.dart';
import 'src/pages/chat.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dialogflow Flutter App',
      initialRoute: prefs.ultimaPagina,
      routes: {
        MyHomePage.routeName : (BuildContext context)=> MyHomePage(title: 'Chat Normal'),
        SettingsPage.routeName : (BuildContext context)=> SettingsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  static final String routeName = 'chat';

  MyHomePage({Key key, this.title}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina = MyHomePage.routeName;
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
