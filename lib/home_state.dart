class HomeState {}

class InitializedHomeState extends HomeState {}

class DataFetchedHomeState extends HomeState {
  final List<String> data;

  DataFetchedHomeState({this.data});

  bool get hasData => data.length > 0;
}

class ErrorHomeState extends HomeState {}

class BusyHomeState extends HomeState {}
