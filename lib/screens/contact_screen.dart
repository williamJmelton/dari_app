import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:call_number/call_number.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  launchMapsNavigation() {
    MapsLauncher.launchQuery('1120 Thorpe Rd, Rocky Mount, NC, 27804');
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 7,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.navigation),
                        title: const Text(
                          'Find Us!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text(
                          'We\'re located in Rocky Mount',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Text(
                        'Address: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '1120 Thorpe Rd, Rocky Mount, NC 27804',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Open Navigation to Warehouse',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      RaisedButton(
                          onPressed: launchMapsNavigation,
                          child: Text('Launch Maps Navigation')),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 7,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(FontAwesomeIcons.solidNewspaper),
                        title: const Text(
                          'Contact Us!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text(
                          'We\'d love to hear from you!',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Column contents vertically,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Column contents horizontally,
                          children: [
                            RaisedButton.icon(
                              // call warehouse
                              icon: Icon(Icons.contact_phone),
                              label: Text('Call Us'),
                              onPressed: () async {
                                await new CallNumber().callNumber("2522121711");
                              },
                            ),
                            RaisedButton.icon(
                              icon: Icon(Icons.web),
                              label: Text('Visit Our Website'),
                              onPressed: () {
                                _launchInBrowser('https://dariwholesales.com');
                              },
                            ),
                            RaisedButton.icon(
                              icon: Icon(FontAwesomeIcons.facebookF),
                              color: Colors.blue,
                              onPressed: () {
                                _launchInBrowser(
                                    'https://www.facebook.com/dariincwholesales');
                              },
                              label: Text('Dari Wholesales Facebook'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
