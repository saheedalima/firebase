import 'package:firebase/Email%20Pass%20Authentication/FireHelper.dart';
import 'package:firebase/Email%20Pass%20Authentication/Login.dart';
import 'package:firebase/Email%20Pass%20Authentication/Welcome_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //to get current userrently logged in user
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MaterialApp(home: user == null ? Login() : Welcome(),));
}

class Registration extends StatefulWidget {

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final email_controller  = TextEditingController();
  final pass_controller  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration"),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: email_controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: pass_controller,
            ),
          ),
          ElevatedButton(onPressed: (){

            String mail = email_controller.text.trim();
            String pass = pass_controller.text.trim();

            FireHelper().signUp(email: mail, password: pass).then((result) {
              if(result == null){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
              }
            });
          }, child: Text("Register"))
        ],
      ),
    );
  }
}
