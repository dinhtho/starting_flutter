import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:starting_flutter/model/user.dart';
import 'item_user.dart';
import 'package:starting_flutter/ui/detail_profile/profile.dart';
import 'package:starting_flutter/ui/users/users_screen_bloc.dart';

class UsersScreen extends StatefulWidget {
  @override
  UsersState createState() => UsersState();
}

class UsersState extends State<UsersScreen> {
  List<User> users = List();
  ScrollController controller;
  final usersScreenBloc = UsersScreenBloc();

  @override
  void initState() {
    super.initState();
    usersScreenBloc.getUsers();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: usersScreenBloc.getUserList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              users = snapshot.data;
              return _buildList();
            } else if (snapshot.hasData) {
              print(snapshot.error);
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildList() {
    return Stack(children: <Widget>[
      RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView.builder(
              itemCount: users.length,
              controller: controller,
              itemBuilder: (context, i) {
                return UserItem(
                  user: users[i],
                  position: i,
                  onItemAction: onItemAction,
                );
              }))
    ]);
  }

  void _scrollListener() {
    if (controller.position.extentAfter == 0) {
//      usersScreenBloc.getUsers();
    }
  }

  Future _handleRefresh() {
   return usersScreenBloc.getUsers();
  }

  onItemAction(ItemActionType actionType, int position) {
    print('actionType $actionType');
    print('position $position');
    if (actionType == ItemActionType.delete) {
      setState(() {
        users.removeAt(position);
      });
    } else if (actionType == ItemActionType.more) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    user: users[position],
                  )));
    }
  }
}
