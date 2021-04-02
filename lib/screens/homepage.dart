import 'package:dari_app/screens/contact_screen.dart';
import 'package:dari_app/screens/new_items_screen.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../newsfeed.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference news = FirebaseFirestore.instance.collection('news');

  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('news');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dari Wholesales'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.newspaper)),
              Tab(icon: Icon(FontAwesomeIcons.atlas)),
              Tab(icon: Icon(FontAwesomeIcons.shoppingCart)),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              tooltip: 'Sign Out',
              icon: Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            NewsList(),
            ContactScreen(),
            NewItemsScreen(),
          ],
        ),
      ),
    );
  }
}
