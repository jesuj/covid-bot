
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del Genero
  int get genero {
    // por defecto masculino
    return _prefs.getInt('genero') ?? 1;
  }

  set genero( int value ) {
    _prefs.setInt('genero', value);
  }


  // GET y SET del nombreUsuario
  String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? 'You';
  }

  set nombreUsuario( String value ) {
    _prefs.setString('nombreUsuario', value);
  }

  // GET y SET de la última página
  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'chat';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

}