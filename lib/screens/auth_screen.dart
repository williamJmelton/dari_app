import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dari_app/widgets/auth/auth_form.dart';

import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String storeName,
      String storeType, bool isLogin, BuildContext ctx) async {
    var authResult; // should be able to recieve AuthResult Type

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(authResult.user.uid)
            .set({
          'storeName': storeName,
          'email': email,
          'storeType': storeType,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            AuthForm(
              _submitAuthForm,
              _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
