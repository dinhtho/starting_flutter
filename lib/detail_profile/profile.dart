import 'package:flutter/material.dart';
import 'package:starting_flutter/model/FriendsModel.dart';

class Profile extends StatefulWidget {
  FriendsModel friendsModel;

  Profile({@required this.friendsModel});

  @override
  State createState() => ProfileStage();
}

class ProfileStage extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: <Widget>[Text(widget.friendsModel.name)],
      ),
    );
  }
}
