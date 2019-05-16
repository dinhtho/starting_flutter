import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:starting_flutter/model/user.dart';
import 'item_user.dart';
import 'package:starting_flutter/ui/detail_profile/profile.dart';

class UsersScreen extends StatefulWidget {
  @override
  UsersState createState() => UsersState();
}

class UsersState extends State<UsersScreen> {
  bool isLoading = true;
  List<User> users = List();
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    getUsers();
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

  getUsers() async {
    isLoading = true;
    var url = 'https://randomuser.me/api/?results=10&nat=us';
    var httpClient = HttpClient();

    List<User> users = List<User>();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonString = await response.transform(utf8.decoder).join();
        Map data = json.decode(jsonString);

        for (var res in data['results']) {
          var objName = res['name'];
          String name =
              objName['first'].toString() + " " + objName['last'].toString();

          final objImage = res['picture'];
          String profileUrl = objImage['large'].toString();
          User user = User(
              name: name, email: res['email'], profileImageUrl: profileUrl);
          users.add(user);
        }
      }
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      this.users.addAll(users);
      isLoading = false;
    });
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter == 0) {
      setState(() {
        isLoading = true;
      });
      getUsers();
    }
  }

  Future _handleRefresh() async {
    setState(() {
      users.clear();
    });
    await getUsers();
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
