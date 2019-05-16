import 'package:dio/dio.dart';

class NetworkProvider extends Dio {
  static final NetworkProvider networkProvider = NetworkProvider._internal();

  factory NetworkProvider() {
    return networkProvider;
  }

  NetworkProvider._internal();
}

class Network {
  static request<T>({
      Future<Response<T>> call,
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
}
