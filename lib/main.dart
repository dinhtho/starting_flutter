import 'package:flutter/material.dart';
import 'package:starting_flutter/friends_list_page.dart';

void main() => runApp(new FlutterDemo());

class FlutterDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "abc",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter Demo"),
        ),

        // body: new Center(child: new ListViewCustom()),
        body: new Center(child: new FriendsPage()),
      ),
    );
  }
}

class ListViewCustom extends StatefulWidget {
  @override
  ListViewCustomState createState() => new ListViewCustomState();
}

class ListViewCustomState extends State<ListViewCustom> {
  var suggestions = ["a", "b", "c"];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
      
          if (i < suggestions.length) {
            return _buildRow(suggestions[i]);
          }
        });
  }

  Widget _buildRow(value) {
    return ListTile(
      title: Text(
        value,
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}
