import 'package:dio/dio.dart';

class NetworkProvider extends Dio {
  static final NetworkProvider networkProvider = NetworkProvider._internal();

  factory NetworkProvider() {
    return networkProvider;
  }

  NetworkProvider._internal();
}

class Network {
  static request<T>(
      {Future<Response<T>> call,
      Function doOnSubscribe,
      Function doOnTerminate,
      Function(T) onSuccess,
      Function(DioError) onError}) async {
    try {
      doOnSubscribe();
      Response<T> response = await call;
      onSuccess(response.data);
    } catch (e) {
      onError(e);
    } finally {
      doOnTerminate();
    }
  }

  static multiRequest<T>(
      {List<Future<Response<T>>> calls,
      Function doOnSubscribe,
      Function doOnTerminate,
      Function(List<T>) onSuccess,
      Function(DioError) onError}) async {
    try {
      doOnSubscribe();
      List<Response<T>> responses = await Future.wait(calls);
      onSuccess(responses.map((response) {
        return response.data;
      }).toList());
    } catch (e) {
      onError(e);
    } finally {
      doOnTerminate();
    }
  }
}
