import 'package:starting_flutter/network/network.dart';
import 'package:starting_flutter/model/user.dart';
import 'dart:async';

class UsersScreenBloc {
  StreamController _streamController = StreamController();

  get getUserList => _streamController.stream;

 Future getUsers() {
    Future call = NetworkProvider()
        .get('https://randomuser.me/api/?results=10&nat=us');
    Network.request(
        call: call,
        doOnSubscribe: () {
          print("loading");
        },
        doOnTerminate: () {
          print("hide loading");
        },
        onSuccess: (data) {
          final users = List<User>();
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
          _streamController.sink.add(users);
        },
        onError: (error) {
          print(error);
        });
    return call;
  }

//    isLoading = true;
//    var url = 'https://randomuser.me/api/?results=10&nat=us';
//    var httpClient = HttpClient();
//
//    List<User> users = List<User>();
//    try {
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.OK) {
//        var jsonString = await response.transform(utf8.decoder).join();
//        Map data = json.decode(jsonString);
//
//        for (var res in data['results']) {
//          var objName = res['name'];
//          String name =
//              objName['first'].toString() + " " + objName['last'].toString();
//
//          final objImage = res['picture'];
//          String profileUrl = objImage['large'].toString();
//          User user = User(
//              name: name, email: res['email'], profileImageUrl: profileUrl);
//          users.add(user);
//        }
//      }
//    } catch (exception) {
//      print(exception.toString());
//    }
//
//    if (!mounted) return;
//
//    setState(() {
//      this.users.addAll(users);
//      isLoading = false;
//    });
//  }

}
