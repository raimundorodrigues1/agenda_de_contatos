import 'package:flutter/material.dart';

import 'package:lista_de_contatos/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          textTheme: TextTheme(),
          primaryColor: Colors.blueGrey,
          accentColor: Colors.cyan[600],
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
          ),
          primaryIconTheme:
              const IconThemeData.fallback().copyWith(color: Colors.black))));
}
