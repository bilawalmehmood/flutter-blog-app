import 'package:blogapp/Upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'authentic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UploadScreen()),
                  );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.upload_file,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut().whenComplete((){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthenticScreen()),
                  );
                }).catchError((error){
                  Fluttertoast.showToast(msg: error.toString());
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
