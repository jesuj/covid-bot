// @dart=2.9
import 'package:covid_bot/src/pages/home_page.dart';
import 'package:covid_bot/src/pages/settings_page.dart';
import 'package:covid_bot/src/settings_user/preferencias_usuario.dart';
import 'package:flutter/material.dart';


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
        HomePage.routeName : (BuildContext context)=> HomePage(title: 'Chat Bot'),
        SettingsPage.routeName : (BuildContext context)=> SettingsPage(),
      },
    );
  }
}
