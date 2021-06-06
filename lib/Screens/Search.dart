import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DioNetwork dio = new DioNetwork();
  List<PositionInMap> streetList = [];
  final ScrollController listScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    this.getAllTracts();
    listScrollController.addListener(_scrollListener);
  }

  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      if (model.isConnected != null) {
        return model.isConnected
            ? Scaffold(
                key: _key,
                body: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SearchBar(
                          hintText: "Cerca una strada",
                          placeHolder: ListView.builder(
                            controller: listScrollController,
                            itemCount: streetList.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                  title: Text(streetList[i].streetName),
                                  subtitle: (streetList[i].section ==
                                          'strada completa')
                                      ? null
                                      : Text(streetList[i].section),
                                  onTap: () => _showDialog(streetList[i]));
                            },
                          ),
                          minimumChars: 2,
                          emptyWidget: Center(
                              child: Text(
                            "Nessuna strada trovata con il seguente nome",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          )),
                          cancellationWidget: Text("Cancella"),
                          debounceDuration: Duration(milliseconds: 500),
                          loader: Center(
                              child: Text(
                            "Cerco...",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          )),
                          onSearch: search,
                          onItemFound: (PositionInMap position, int index) {
                            return ListTile(
                                title: Text(position.streetName),
                                subtitle:
                                    (position.section == 'strada completa')
                                        ? null
                                        : Text(position.section),
                                onTap: () => _showDialog(position));
                          },
                        ))),
              )
            : NoInternet();
      }
      return Center(child: CircularProgressIndicator());
    });
}
