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
  List<User> users;
  ScrollController controller;
  final usersScreenBloc = UsersScreenBloc();
  bool isLoadMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => usersScreenBloc.getUsers());
    controller = ScrollController()..addListener(_scrollListener);
    usersScreenBloc.getUserList.where((e) => e.error != null).listen((e) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(e.error.toString()),
      ));
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
      RefreshIndicator(
          onRefresh: _handleRefresh,
          child: StreamBuilder(stream: usersScreenBloc.getUserList.where((e) {
            return e?.data != null;
          }), builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (isLoadMore) {
                users.addAll(snapshot.data.data);
                isLoadMore = false;
              } else {
                users = snapshot.data.data;
              }
              return ListView.builder(
                  itemCount: users.length,
                  controller: controller,
                  itemBuilder: (context, i) {
                    return UserItem(
                      user: users[i],
                      position: i,
                      onItemAction: onItemAction,
                    );
                  });
            }
            return Container();
          })),
      StreamBuilder(stream: usersScreenBloc.getUserList.where((e) {
        return e?.isLoading != null;
      }), builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
      }),
    ]));
  }

  void _scrollListener() {
    if (controller.position.extentAfter == 0) {
      isLoadMore = true;
      usersScreenBloc.getUsers();
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
