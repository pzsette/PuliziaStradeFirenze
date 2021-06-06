import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';

class FavouriteButton extends StatefulWidget {
  final PositionInMap position;
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 2.0, color: Colors.red),
            shape: CircleBorder(),
            primary: Colors.white,
          ),
          onPressed: () {},
          child: Padding(
              padding: EdgeInsets.all(7),
              child: Icon(
                  positionInFavourites ? Icons.favorite : Icons.favorite_border,
                  size: screenWidth / 14,
                  color: Colors.red))),
    );
  }
}
