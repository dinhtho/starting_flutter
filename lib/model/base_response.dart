

class BaseResponse<T>{
  T data;
  bool isLoading;
  Error error;

  BaseResponse({this.data, this.isLoading, this.error});


}