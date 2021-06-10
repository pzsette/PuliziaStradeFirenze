import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/NotificationButton.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/DateLabel.dart';
import 'package:pulizia_strade/CustomWidgets/Labels/PositionLabel.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Repository/favourites_db.dart';

class FavouritePositionCard extends StatefulWidget {
  final PositionInMap position;
  final DioNetwork dio = new DioNetwork();

  FavouritePositionCard({Key key, this.position}) : super(key: key);

  @override
  _PositionWidgetState createState() => _PositionWidgetState();
}

class _PositionWidgetState extends State<FavouritePositionCard> {
  bool notification;
  var latitude;
  var longitude;
  //FireMessaging fireMessaging = new FireMessaging();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider provider = Provider.of<DataProvider>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        elevation: 10,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.grey[300])),
        child: FutureBuilder(
            future: Future.wait([
              widget.dio.getParkingInfoOnPosition(widget.position),
              //DBHelper.instance.checkIfPositionInFavourite(widget.position)
              DBHelper.instance.getNotification(widget.position)
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              Widget result;
              if (snapshot == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                result = Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 3.0,
                    )));
              } else {
                result = Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth / 42,
                              vertical: screenWidth / 42),
                          child: PositionLabel(widget.position)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth / 42,
                              vertical: screenWidth / 42),
                          child: DateLabel(widget.position, snapshot.data[0])),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: screenWidth / 42),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              NotificationButton(
                                  widget.position, snapshot.data[1]),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                        width: 2.0, color: Colors.red),
                                    shape: CircleBorder(),
                                    primary: Colors.white,
                                  ),
                                  onPressed: () {
                                    provider.deletePosition(widget.position);
                                    fireMessaging.removeFavourites(
                                        widget.position.streetName,
                                        widget.position.section);
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.all(7),
                                      child: Icon(
                                        Icons.delete,
                                        size: screenWidth / 13,
                                        color: Colors.red,
                                      ))),
                            ],
                          )),
                    ],
                  ),
                );
              }
              return result;
            }));
  }
}
