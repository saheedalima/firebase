import 'package:firebase/Email%20Pass%20Authentication/FireHelper.dart';
import 'package:firebase/Email%20Pass%20Authentication/Registration.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome User...!"),),
      body: Center(
        child: ElevatedButton(onPressed: (){
          FireHelper().signout().then((W_result) =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Registration())));
        }, child: Text("SignOut")),
      ),
    );
  }
}
