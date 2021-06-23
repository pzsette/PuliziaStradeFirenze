import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/CustomWidgets/FavouritePositionCard.dart';
import 'package:pulizia_strade/Providers/ConnectivityProvider.dart';
import 'package:pulizia_strade/Providers/DataProvider.dart';
import 'package:pulizia_strade/Screens/NoInternet.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final dio = new Dio();

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<ConnectivityProvider, DataProvider>(
        builder: (context, connModel, dataModel, child) {
      if (connModel.isConnected != null) {
        return connModel.isConnected
            ? Container(
                child: dataModel.items.length == 0
                    ? Center(
                        child: Text(
                        "Nessuna strada aggiunta ai preferiti",
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth / 23),
                      ))
                    : ListView.builder(
                        itemCount: dataModel.items.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              width: double.maxFinite,
                              child: FavouritePositionCard(
                                  key: new Key(index.toString()),
                                  position: dataModel.items[index]));
                        }))
            : NoInternet();
      }
      return Center(child: CircularProgressIndicator());
    });
  }
}
