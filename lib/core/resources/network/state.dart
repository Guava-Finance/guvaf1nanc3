sealed class AppState {}

class LoadedState extends AppState {
  final dynamic data;

  LoadedState(this.data);
}

class ErrorState extends AppState {
  final String msg;

  ErrorState(this.msg);
}

class NoInternetState extends AppState {
  final String msg;

  NoInternetState(this.msg);
}

class RpcErrorState extends AppState {
  final String msg;

  RpcErrorState(this.msg);
}
