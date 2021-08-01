import 'package:covid_bot/main.dart';
import 'package:covid_bot/src/pages/chat.dart';
import 'package:covid_bot/src/pages/settings_page.dart';
import 'package:flutter/material.dart';



class MenuWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/menu-img.jpg'),
                    fit: BoxFit.cover
                )
            ),
          ),

          ListTile(
            leading: Icon( Icons.pages, color: Colors.blue ),
            title: Text('Chat Normal'),
            onTap: ()=> Navigator.pushReplacementNamed(context, MyHomePage.routeName ) ,
          ),

          ListTile(
            leading: Icon( Icons.people, color: Colors.blue ),
            title: Text('Chat Voz'),
            onTap: (){ },
          ),

          ListTile(
              leading: Icon( Icons.settings, color: Colors.blue ),
              title: Text('Settings'),
              onTap: (){
                // Navigator.pop(context);
                Navigator.pushReplacementNamed(context, SettingsPage.routeName  );
              }
          ),

        ],
      ),
    );
  }
}