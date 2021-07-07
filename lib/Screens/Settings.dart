import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/Models/SettingsValues.dart';
import 'package:pulizia_strade/Providers/SettingsProvider.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';
import 'package:pulizia_strade/Utils/utils.dart';
import 'package:pulizia_strade/Utils/NavigationUtils.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 14.0);
  final TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 14.0);

  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, model, child) {
      return Scaffold(
        body: Container(child: buildSettingsList()),
        resizeToAvoidBottomInset: false,
      );
    });
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          tiles: [
            SettingsTile(
                title: 'Ora notifica',
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationTime()),
                  );
                },
                subtitle: convertNotificationTimeValueToString(
                    Provider.of<SettingsProvider>(context).selectedValue),
                leading: Icon(Icons.alarm)),
          ],
        ),
        SettingsSection(tiles: [
          SettingsTile(
            title: 'Termini di servizio',
            leading: Icon(Icons.description),
            onPressed: (BuildContext context) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermOfService()),
              );
            },
          ),
        ]),
        CustomSection(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
            child: Column(
              children: [
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          style: defaultStyle,
                          text:
                              "Se riscontri dei problemi nell'utilizzo dell'app, puoi contattarci all'indirizzo email: "),
                      TextSpan(
                          text: "pietrozarri96@gmail.com",
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl('mailto:pietrozarri96@gmail.com');
                            }),
                    ], style: TextStyle(fontSize: 15))),
                SizedBox(height: 20),
                Text(
                  'Versione: 1.0.0',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class NotificationTime extends StatefulWidget {
  @override
  _NotificationTimeState createState() => _NotificationTimeState();
}

class _NotificationTimeState extends State<NotificationTime> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsPrivider = Provider.of<SettingsProvider>(context);
    NotificationTimeOptions _notTime = settingsPrivider.selectedValue;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[400], title: Text("Orario notifica")),
      body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
        RadioListTile(
          title: Text(
            'Un giorno prima',
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2),
          ),
          value: NotificationTimeOptions.one_day,
          groupValue: _notTime,
          onChanged: (NotificationTimeOptions value) {
            settingsPrivider.changeNotificationHours(value);
          },
        ),
        RadioListTile(
          title: Text(
            '12 ore prima',
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2),
          ),
          value: NotificationTimeOptions.twelve_hours,
          groupValue: _notTime,
          onChanged: (NotificationTimeOptions value) {
            settingsPrivider.changeNotificationHours(value);
          },
        ),
        RadioListTile(
          title: Text(
            '6 ore prima',
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2),
          ),
          value: NotificationTimeOptions.six_hours,
          groupValue: _notTime,
          onChanged: (NotificationTimeOptions value) {
            settingsPrivider.changeNotificationHours(value);
          },
        ),
        RadioListTile(
          title: Text(
            '2 ore prima',
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2),
          ),
          value: NotificationTimeOptions.two_hours,
          groupValue: _notTime,
          onChanged: (NotificationTimeOptions value) {
            settingsPrivider.changeNotificationHours(value);
          },
        ),
      ]).toList()),
    );
  }
}

class TermOfService extends StatelessWidget {
  final TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 16.0);
  final TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Termini di Servizio"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: RichText(
            text: TextSpan(children: <TextSpan>[
          TextSpan(
              style: defaultStyle,
              text:
                  "I dati sono presi dal dataset pubblico del comune di Firenze, e non sono stati modificati. Il link alla licenza è: "),
          TextSpan(
              text: 'www.creativecommons.org/licenses/by-sa/3.0/it/legalcode',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("tap");
                  String url = Uri.encodeFull(
                      'https://www.creativecommons.org/licenses/by-sa/3.0/it/legalcode');
                  launchUrl(url);
                }),
        ], style: TextStyle(fontSize: 15))),
      ),
    );
  }
}
