import 'package:starting_flutter/network/network.dart';
import 'package:starting_flutter/model/user.dart';
import 'dart:async';
import 'package:starting_flutter/model/base_response.dart';

class UsersScreenBloc {
  StreamController _streamController = StreamController.broadcast();

  Stream get getUserList => _streamController.stream;

  Future getUsers() {
    Future call =
        NetworkProvider().get('https://randomuser.me/api/?results=10&nat=us');
    Network.request(
        call: call,
        doOnSubscribe: () {
          _streamController.sink.add(BaseResponse(isLoading: true));
        },
        doOnTerminate: () {
          _streamController.sink.add(BaseResponse(isLoading: false));
        },
        onSuccess: (data) {
          final users = parseJson(data);
          _streamController.sink.add(BaseResponse<List<User>>(data: users));
        },
        onError: (error) {
          _streamController.sink.add(BaseResponse(error: error));
        });
    return call;
  }

  List<User> parseJson(Map<String, dynamic> data) {
    final users = List<User>();
    for (var res in data['results']) {
      var objName = res['name'];
      String name =
          objName['first'].toString() + " " + objName['last'].toString();

      final objImage = res['picture'];
      String profileUrl = objImage['large'].toString();
      User user =
          User(name: name, email: res['email'], profileImageUrl: profileUrl);
      users.add(user);
    }
    return users;
  }
}
