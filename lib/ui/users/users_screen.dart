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
  bool isLoading = true;
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
    Stack stack = Stack(children: <Widget>[
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

    if (isLoading) {
      stack.children.add(Center(child: CircularProgressIndicator()));
    }
    return stack;
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter == 0) {
      setState(() {
        isLoading = true;
      });
      usersScreenBloc.getUsers();
    }
  }

  Future _handleRefresh() async {
    setState(() {
      users.clear();
    });
    await usersScreenBloc.getUsers();
    return null;
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
