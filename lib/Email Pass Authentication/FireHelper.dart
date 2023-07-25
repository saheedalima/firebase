import 'package:firebase_auth/firebase_auth.dart';

class FireHelper{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  get user =>firebaseAuth.currentUser;

//firebase password must have 7 umbers
  //signup
 Future<String?> signUp({required String email,required String password}) async{
  try {
     await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
     return null;

  } on FirebaseAuthException catch (e) {
    return e.message;

  } catch (e) {
    print(e);
  }

}
//signIn
  Future<String?> signIn({required String email,required String password}) async {
    try {
       await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signout
Future<void> signout() async{
   await firebaseAuth.signOut();
}
}