import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:starting_flutter/model/FriendsModel.dart';
import 'item.dart';
import '../detail_profile/profile.dart';

class FriendsPage extends StatefulWidget {
  @override
  FriendsState createState() => FriendsState();
}

class FriendsState extends State<FriendsPage> {
  bool isProgressBarShown = true;
  List<FriendsModel> listFriends = List();
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
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
              itemCount: listFriends.length,
              controller: controller,
              itemBuilder: (context, i) {
                return MyRow(
                  friendsModel: listFriends[i],
                  position: i,
                  onItemAction: onItemAction,
                );
              }))
    ]);

    if (isProgressBarShown) {
      stack.children.add(Center(child: CircularProgressIndicator()));
    }
    return stack;
  }

  _fetchFriendsList() async {
    isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=10&nat=us';
    var httpClient = HttpClient();

    List<FriendsModel> listFriends = List<FriendsModel>();
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

          var objImage = res['picture'];
          String profileUrl = objImage['large'].toString();
          FriendsModel friendsModel =
              FriendsModel(name, res['email'], profileUrl);
          listFriends.add(friendsModel);
          print(friendsModel.profileImageUrl);
        }
      }
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      this.listFriends.addAll(listFriends);
      isProgressBarShown = false;
    });
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter == 0) {
      setState(() {
        isProgressBarShown = true;
      });
      _fetchFriendsList();
    }
  }

  Future _handleRefresh() async {
    setState(() {
      listFriends.clear();
    });
    await _fetchFriendsList();
    return null;
  }

  onItemAction(ItemActionType actionType, int position) {
    print('actionType $actionType');
    print('position $position');
    if (actionType == ItemActionType.delete) {
      setState(() {
        listFriends.removeAt(position);
      });
    } else if (actionType == ItemActionType.more) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    friendsModel: listFriends[position],
                  )));
    }
  }
}
