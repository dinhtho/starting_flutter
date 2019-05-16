import 'package:flutter/material.dart';
import 'package:starting_flutter/model/user.dart';

class Profile extends StatefulWidget {
  User user;

  Profile({@required this.user});

  @override
  State createState() => ProfileStage();
}

class ProfileStage extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: <Widget>[Text(widget.user.name)],
      ),
    );
  }
}
