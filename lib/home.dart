import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/Screens/Map.dart';
import 'package:pulizia_strade/Screens/Search.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';
import 'Providers/ConnectivityProvider.dart';
import 'Screens/Favourite.dart';
import 'Screens/Settings.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  final String title = "Pulizia Strade";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool pageToggle = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  static List<Widget> _widgetOptions = <Widget>[
    MapScreen(),
    SearchScreen(),
    FavouriteScreen(),
    SettingsScreen(),
  ];

  Widget createAppBar(bool) {
    if (bool) {
      return AppBar(
          backgroundColor: Colors.blue[400],
          title: Text("Impostazioni"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              if (!mounted) return;
              setState(() {
                pageToggle = false;
              });
            },
          ));
    } else {
      return AppBar(
          backgroundColor: Colors.blue[400],
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                if (!mounted) return;
                setState(() {
                  pageToggle = true;
                });
              },
            )
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: createAppBar(pageToggle),
      body: (pageToggle ? SettingsScreen() : _widgetOptions[_selectedIndex]),
      //body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      bottomNavigationBar: !pageToggle
          ? Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
              ]),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: GNav(
                      gap: 8,
                      activeColor: Colors.white,
                      iconSize: 24,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      duration: Duration(milliseconds: 300),
                      tabBackgroundColor: Colors.blue[400],
                      tabs: [
                        GButton(
                          icon: LineIcons.map,
                          text: 'Mappa',
                        ),
                        GButton(
                          icon: LineIcons.search,
                          text: 'Cerca',
                        ),
                        GButton(
                          icon: LineIcons.heart_o,
                          text: 'Preferiti',
                        ),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        if (!mounted) return;
                        setState(() {
                          pageToggle = false;
                          _selectedIndex = index;
                        });
                      }),
                ),
              ),
            )
          : null,
    );
  }
}
