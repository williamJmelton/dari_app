import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewsList extends StatelessWidget {
  String readTimestamp(Timestamp timestamp) {
    var now = DateTime.now();
    var format = DateFormat('hh:mm a');
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    var diff = now.difference(date);
    var time = '';

    print('diff in seconds: ${diff.inSeconds}');

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = "Today at " + format.format(date);
      if (diff.inMinutes < 60) {
        time = '1 hour ago';
      }
      if (diff.inMinutes < 30) {
        time = 'few minutes ago';
      } 
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' Day Ago';
      } else {
        time = diff.inDays.toString() + ' Days Ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' Week Ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' Weeks Ago';
      }
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('news')
        .orderBy('date', descending: true);

    return Container(
      // margin: EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(
                  document.data()['title'] +
                      ' • ' +
                      readTimestamp(document.data()['date']),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: new Text(document.data()['description']),
                trailing: Icon(Icons.new_releases),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
