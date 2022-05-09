import 'dart:io';

import 'package:chat_app/pickers/user_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.authenticateUser, this.isloading);

  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool islogin,
  ) authenticateUser;

  final bool isloading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();

  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";

  bool _isLogin = true;
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;

  }

  void _submitform() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text( 
          "Please pick an image",
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formkey.currentState!.save();
      widget.authenticateUser(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile!,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImage(_pickedImage),
                  TextFormField(
                    key: const ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: "Email Address"),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey("password"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return "Password must be at least 4 characters long.";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return "Please enter atleast 4 characters";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "Username"),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isloading) const CircularProgressIndicator(),
                  if (!widget.isloading)
                    ElevatedButton(
                        onPressed: _submitform,
                        child: Text(_isLogin ? "Login" : "SignUp")),
                  if (!widget.isloading)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? "Create New Account"
                            : "Already have an account"))
                ],
              )),
        ),
      ),
    );
  }
}
