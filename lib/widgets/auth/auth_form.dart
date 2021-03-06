import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn);
  final void Function(
    String email,
    String password,
    String firstName,
    String lastName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userPassword = '';
  String _userFirstName = '';
  String _userLastName = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    //close the keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userFirstName.trim(),
        _userLastName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be atleast 7 character long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('firstName'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter First Name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                      ),
                      onSaved: (value) {
                        _userFirstName = value;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('lastName'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Last Name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                      ),
                      onSaved: (value) {
                        _userLastName = value;
                      },
                    ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    child: Text(_isLogin ? 'Log in' : 'Sign up!'),
                    onPressed: _trySubmit,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurpleAccent,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.deepPurpleAccent,
                    ),
                    child: Text(_isLogin ? 'Sign up!' : 'Log in'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
