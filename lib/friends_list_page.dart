import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:starting_flutter/model/FriendsModel.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<FriendsPage> {
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<FriendsModel> _listFriends = new List();
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = new Stack(children: <Widget>[
      new RefreshIndicator(
          onRefresh: _handleReresh,
          child: new ListView.builder(
              itemCount: _listFriends.length,
              controller: controller,
              itemBuilder: (context, i) {
                return _buildRow(_listFriends[i], i);
              }))
    ]);

    if (_isProgressBarShown) {
      stack.children.add(new Center(child: new CircularProgressIndicator()));
    }

    return new Scaffold(body: stack);
  }

  Widget _buildRow(FriendsModel friendsModel, int i) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
      ),
      title: new Text(
        friendsModel.name,
        style: _biggerFont,
      ),
      subtitle: new Text(friendsModel.email),
      onTap: () {
        print('click' + i.toString());
        setState(() {});
      },
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=10&nat=us';
    var httpClient = new HttpClient();

    List<FriendsModel> listFriends = new List<FriendsModel>();
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
              new FriendsModel(name, res['email'], profileUrl);
          listFriends.add(friendsModel);
          print(friendsModel.profileImageUrl);
        }
      }
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      _listFriends.addAll(listFriends);
      _isProgressBarShown = false;
    });
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter == 0) {
      setState(() {
        _isProgressBarShown = true;
      });
      _fetchFriendsList();
    }
  }

  Future _handleReresh() async {
    setState(() {
      _listFriends.clear();
    });
    await _fetchFriendsList();
    return null;
  }
}
