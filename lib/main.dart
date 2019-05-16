import 'package:flutter/material.dart';
import 'package:starting_flutter/ui/users/users_screen.dart';

void main() =>
    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: UsersScreen(),
      ),
    ));
