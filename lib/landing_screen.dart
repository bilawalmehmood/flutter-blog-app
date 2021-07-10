import 'package:blogapp/HomeScreen.dart';
import 'package:blogapp/authentic_screen.dart';
import 'package:blogapp/widget/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandigScreen extends StatefulWidget {
  const LandigScreen({Key key}) : super(key: key);

  @override
  _LandigScreenState createState() => _LandigScreenState();
}

class _LandigScreenState extends State<LandigScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.active){
          User user=snapshot.data;
          if(user==null)
            return AuthenticScreen();
          return HomeScreen();
        }
        else{
          return Scaffold(
            body: Center(
              child: circularProgress(),
            ),
          );
        }

      },
    );
  }
}
