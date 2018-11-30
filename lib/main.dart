import 'package:flutter/material.dart';
import 'package:starting_flutter/friends_page/friends_list_page.dart';

void main() =>
    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Demo"),
        ),
        body: FriendsPage(),
      ),
    ));
