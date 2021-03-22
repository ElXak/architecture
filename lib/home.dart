import 'dart:async';

import 'package:flutter/material.dart';

enum HomeViewState {
  Busy,
  DataRetrieved,
  NoData,
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final StreamController<HomeViewState> stateController =
      StreamController<HomeViewState>();

  List<String> listItems;

  @override
  void initState() {
    _getListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: StreamBuilder(
        stream: stateController.stream,
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) return _getInformationMessage(snapshot.error);

          if (!snapshot.hasData || snapshot.data == HomeViewState.Busy)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data == HomeViewState.NoData)
            return _getInformationMessage(
                'No data found for your account. Add something and check back.');

          return ListView.builder(
            itemCount: listItems.length,
            itemBuilder: (buildContext, index) =>
                _getListItemUi(index, listItems),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getListData(),
      ),
    );
  }

  Future _getListData({
    bool hasError = false,
    bool hasData = true,
  }) async {
    stateController.add(HomeViewState.Busy);
    await Future.delayed(Duration(seconds: 2));

    if (hasError)
      return stateController.addError(
          'An error occurred while fetching the data. Please try again later.');

    if (!hasData) return stateController.add(HomeViewState.NoData);

    listItems = List<String>.generate(10, (index) => '$index title');
    stateController.add(HomeViewState.DataRetrieved);
  }

  Widget _getListItemUi(int index, List<String> listItems) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[600],
      ),
      child: Center(
        child: Text(
          listItems[index],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _getInformationMessage(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
