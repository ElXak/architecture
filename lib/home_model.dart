import 'dart:async';

import 'home_event.dart';
import 'home_state.dart';

enum HomeViewState {
  Busy,
  DataRetrieved,
  NoData,
}

class HomeModel {
  final StreamController<HomeState> _stateController =
      StreamController<HomeState>();

  List<String> _listItems;

  // -- Public interface for the home model --

  // Stream that broadcasts the home state
  Stream<HomeState> get homeState => _stateController.stream;

  void dispatch(HomeEvent event) {
    print('Event dispatched: $event');
    if (event is FetchData) {
      _getListData(hasError: event.hasError, hasData: event.hasData);
    }
  }

  // -- --

  Future _getListData({
    bool hasError = false,
    bool hasData = true,
  }) async {
    _stateController.add(BusyHomeState());
    await Future.delayed(Duration(seconds: 2));

    if (hasError)
      return _stateController.addError(
          'An error occurred while fetching the data. Please try again later.');

    if (!hasData) return _stateController.add(DataFetchedHomeState(data: []));

    _listItems = List<String>.generate(10, (index) => '$index title');
    _stateController.add(DataFetchedHomeState(data: _listItems));
  }
}
