import 'package:guavafinance/core/resources/network/state.dart';

extension AppStateExtention on AppState {
  /// This checks whether the AppState response is an error
  bool get isError => (this is ErrorState);

  /// if it's an error get the message
  String get errorMessage => (this as ErrorState).msg;

  dynamic get responseData => (this as LoadedState).data;

  /// This checks whether the AppState response is no Internet
  bool get noInternetConnection => (this is NoInternetState);
}
