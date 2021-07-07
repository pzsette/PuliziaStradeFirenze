import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/CustomWidgets/PositionCard.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Providers/ConnectivityProvider.dart';
import 'package:pulizia_strade/Screens/NoInternet.dart';

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
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
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

  _scrollListener() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void getAllTracts() async {
    try {
      Map response = await dio.getAllStreetsAndTracts(context);
      List<PositionInMap> tmpList = [];
      for (int i = 0; i < response['strade'].length; i++) {
        String streetName = response['strade'][i][0];
        String section = response['strade'][i][1];
        PositionInMap position =
            new PositionInMap(streetName, "Florence", section: section);
        tmpList.add(position);
      }
      setState(() {
        streetList = tmpList;
      });
    } on Exception {
      setState(() {
        streetList = List.empty();
      });
    }
  }

  Future<List<PositionInMap>> search(String search) async {
    List<PositionInMap> searchResult = [];
    streetList.forEach((element) {
      if (element.streetName.contains(search.toUpperCase())) {
        searchResult.add(element);
      }
    });
    return searchResult;
  }

  void _showDialog(PositionInMap position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Container(height: 500, child: PositionCard(position));
      },
    );
  }
}
