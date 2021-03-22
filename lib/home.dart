import 'package:flutter/material.dart';

import 'home_event.dart';
import 'home_model.dart';
import 'home_state.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final model = HomeModel();

  @override
  void initState() {
    model.dispatch(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: StreamBuilder(
        stream: model.homeState,
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) return _getInformationMessage(snapshot.error);

          var homeState = snapshot.data;

          if (!snapshot.hasData || homeState is BusyHomeState)
            return Center(child: CircularProgressIndicator());

          if (homeState is DataFetchedHomeState) if (!homeState.hasData)
            return _getInformationMessage(
                'No data found for your account. Add something and check back.');

          return ListView.builder(
            itemCount: homeState.data.length,
            itemBuilder: (buildContext, index) =>
                _getListItemUi(index, homeState.data),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.dispatch(FetchData(hasData: false)),
      ),
    );
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
