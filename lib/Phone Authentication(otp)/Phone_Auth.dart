import 'package:firebase/Phone%20Authentication(otp)/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phone_Auth());
}

class Phone_Auth extends StatefulWidget {

  @override
  State<Phone_Auth> createState() => _Phone_AuthState();
}

class _Phone_AuthState extends State<Phone_Auth> {
  final phone_controller = TextEditingController();

  final otp_controller = TextEditingController();

  String phonenumber= '';

  String otp= '';

  FirebaseAuth firebaseAuth_phone = FirebaseAuth.instance;

  bool otpfieldvisibility = false;

  void verifyuserPhonenumber(){
    firebaseAuth_phone.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credentials)async{
          firebaseAuth_phone.signInWithCredential(credentials).then((value)async{
            if(value.user != null){
              Navigator.of(context as BuildContext).pushReplacement(
                  MaterialPageRoute(builder: (context)=>Home()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e){
           print(e.message);
    },
        codeSent: (String recieveotp , int? resendtoken){
          otp = recieveotp;
          otpfieldvisibility =true;
        },
        codeAutoRetrievalTimeout: (String verificaionId){});
  }

  Future<void> verifyotp()async{
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: otp,
        smsCode: otp_controller.text);
    firebaseAuth_phone.signInWithCredential(phoneAuthCredential).then((value){
      if(value != null){
       Navigator.of(context as BuildContext).pushReplacement(MaterialPageRoute(builder: (context)=>Home()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Phone Authentication",
      style: TextStyle(fontSize: 20),)),),
      body: Center(
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: phone_controller,
              decoration: InputDecoration(
                hintText: "enter your phone number"
              ),
              onTap: (){
              },
            ),
            Visibility(
              visible: otpfieldvisibility,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: otp_controller,
                decoration: InputDecoration(
                    hintText: "enter your Otp"
                ),
              ),
            ),
            ElevatedButton(onPressed: (){
              if(otpfieldvisibility){
                verifyotp();
              }else{
                verifyuserPhonenumber();
              }
              FocusManager.instance.primaryFocus?.unfocus();
            }, child: Text(otpfieldvisibility ? 'login' : 'verify')),
          ],
        ),
      ),
    );
  }
}
