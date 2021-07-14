import 'package:flutter/material.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/FireMessaging.dart';
import 'package:pulizia_strade/Repository/favourites_db.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';

class NotificationButton extends StatefulWidget {
  final PositionInMap position;
  final bool initNot;

  NotificationButton(this.position, this.initNot);

  @override
  _NotificationButton createState() => _NotificationButton();
}

class _NotificationButton extends State<NotificationButton> {
  bool notificationOn;

  @override
  void initState() {
    super.initState();
    notificationOn = widget.initNot;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              width: 2.0, color: notificationOn ? Colors.green : Colors.grey),
          shape: CircleBorder(),
          primary: Colors.white,
        ),
        onPressed: () {
          DBHelper.instance.updateNot(widget.position, !notificationOn);
          FireMessaging fireMessaging = new FireMessaging();
          if (notificationOn) {
            //widget.messaging.unsubscribeFromTopic(address_revisisted + "-" + tract_revisited);
            fireMessaging.removeFavourites(
                widget.position.streetName, widget.position.section);
          } else {
            //widget.messaging.subscribeToTopic(address_revisisted + "-" + tract_revisited);
            fireMessaging.addFavourites(
                widget.position.streetName, widget.position.section);
          }
          setState(() {
            notificationOn = !notificationOn;
          });
        },
        child: Padding(
            padding: EdgeInsets.all(7),
            child: Icon(
              notificationOn
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              size: SizeConfig.blockSizeVertical * 4,
              color: notificationOn ? Colors.green : Colors.grey,
            )));
  }
}
