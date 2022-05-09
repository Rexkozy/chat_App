import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _loading = false;
  void _tryAuthenticate(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _loading = true;
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
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(image).whenComplete(() => null);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user?.uid)
            .set({
          "username": username,
          "email": email,
          "image_url": url,
        });
      }
    } on FirebaseException catch (err) {
      var message = "An error occured. Please check your credentials!";

      if (err.message != null) {
        message = err.message.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));

      setState(() {
        _loading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: RichText(
            text: const TextSpan(
              text: "CHAT APP",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: AuthForm(_tryAuthenticate, _loading),
    );
  }
}
