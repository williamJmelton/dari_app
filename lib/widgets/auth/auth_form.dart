import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String storeName,
    String storeType,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // ignore: avoid_init_to_null
  String dropdownValue = null;
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  // form values
  var _storeName = '';
  var _email = '';
  var _password = '';
  var _storeType = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      // if this is true all validators returned null
      _formKey.currentState.save();
      widget.submitFn(
        _email.trim(),
        _password.trim(),
        _storeName.trim(),
        _storeType,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _isLogin
                        ? Container()
                        : TextFormField(
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'user name must be at least 6 characters';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.name,
                            key: ValueKey('storeName'),
                            onSaved: (newValue) {
                              _storeName = newValue;
                            },
                            decoration: InputDecoration(
                              labelText: 'Store Name',
                            ),
                          ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains("@")) {
                          return 'please enter a valid email address';
                        }
                        return null;
                      },
                      key: ValueKey('email'),
                      onSaved: (newValue) {
                        _email = newValue;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      key: ValueKey('password'),
                      onSaved: (newValue) {
                        _password = newValue;
                      },
                    ),
                    _isLogin
                        ? Container()
                        : Container(
                            // width: double.infinity,
                            // height: 50,
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              hint: Text('What kind of store do you have?'),
                              // icon: Icon(Icons.arrow_downward),
                              // iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  decorationColor: Colors.deepOrange),
                              underline: Container(
                                height: 2,
                                color: Colors.deepOrange,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                                _storeType = newValue;
                              },
                              items: <String>[
                                'Convenience Store',
                                'Tobacco Shop',
                                'Gas Station',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                    key: ValueKey('storeType'));
                              }).toList(),
                            ),
                          ),
                    SizedBox(height: 12),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        child: Text(_isLogin ? 'Login' : 'Create Account'),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(_isLogin
                            ? 'Create an Account'
                            : 'I already have an account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
