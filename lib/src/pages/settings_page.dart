import 'package:covid_bot/src/settings_user/preferencias_usuario.dart';
import 'package:covid_bot/src/widget/menu_widget.dart';
import 'package:flutter/material.dart';
//import 'package:preferenciasusuarioapp/src/widgets/menu_widget.dart';


class SettingsPage extends StatefulWidget {

  static final String routeName = 'settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  int? _genero;

  late TextEditingController _textController;

  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    prefs.ultimaPagina = SettingsPage.routeName;
    _genero = prefs.genero;
    String nombre = prefs.nombreUsuario;
    _textController = TextEditingController( text: nombre.length>0?nombre:'You');
  }


  _setSelectedRadio( int? valor ) {

    prefs.genero = valor ?? 1;
    _genero = valor;
    setState(() {});

  }


  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    return Scaffold(
        appBar: AppBar(
          title: Text('Ajustes'),
          backgroundColor: (prefs.genero==1)? Colors.blue:Colors.amber,
        ),
        drawer: MenuWidget(),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              child: Text('Settings', style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold )),
            ),

            Divider(),

            RadioListTile(
              value: 1,
              title: Text('Masculino'),
              groupValue: _genero,
              onChanged: _setSelectedRadio,
            ),

            RadioListTile(
                value: 2,
                title: Text('Femenino'),
                groupValue: _genero,
                onChanged: _setSelectedRadio
            ),

            Divider(),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  helperText: 'Nombre de la persona usando el teléfono',
                ),
                onChanged: ( value ) {
                  prefs.nombreUsuario = value;
                },
              ),
            )
          ],
        )
    );
  }
}