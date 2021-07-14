import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/FireMessaging.dart';
import 'package:pulizia_strade/Providers/DataProvider.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

class FavouriteButton extends StatefulWidget {
  final PositionInMap position;
  final FireMessaging fireMessaging = new FireMessaging();
  final bool initFav;

  FavouriteButton(this.position, this.initFav);

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool positionInFavourites;

  @override
  void initState() {
    positionInFavourites = widget.initFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider provider = Provider.of<DataProvider>(context);
    return Container(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 2.0, color: Colors.red),
            shape: CircleBorder(),
            primary: Colors.white,
          ),
          onPressed: () {
            if (!positionInFavourites) {
              widget.fireMessaging.addFavourites(
                  widget.position.streetName, widget.position.section);
              provider.insertPosition(widget.position);
            } else {
              provider.deletePosition(widget.position);
              widget.fireMessaging.removeFavourites(
                  widget.position.streetName, widget.position.section);
            }
            setState(() {
              positionInFavourites = !positionInFavourites;
            });
          },
          child: Padding(
              padding: EdgeInsets.all(7),
              child: Icon(
                  positionInFavourites ? Icons.favorite : Icons.favorite_border,
                  size: SizeConfig.blockSizeVertical * 4,
                  color: Colors.red))),
    );
  }
}
