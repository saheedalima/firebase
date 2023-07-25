import 'package:firebase/Email%20Pass%20Authentication/Welcome_Screen.dart';
import 'package:flutter/material.dart';

import 'FireHelper.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final L_email_controller = TextEditingController();
  final L_pass_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: L_email_controller,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: L_pass_controller,
          ),
        ),
        ElevatedButton(onPressed: (){

          String L_mail = L_email_controller.text.trim();
          String L_pass = L_pass_controller.text.trim();

          FireHelper().signIn(email: L_mail, password: L_pass).then((L_result) {
            if(L_result == null){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Welcome()));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L_result)));
            }
          });
        }, child: Text("Login"))
      ],
    );
  }
}
