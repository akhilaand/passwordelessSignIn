import 'package:firebase_auth/firebase_auth.dart';
import 'package:passwordles_sign_in/common/strings.dart';

class PasswordlessLoginServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signInWithEmailandLink(userEmail)async{
    var _userEmail=userEmail;
    return await _auth.sendSignInLinkToEmail(
        email: _userEmail,
        actionCodeSettings: ActionCodeSettings(
          url:url ,
          handleCodeInApp: true,
          androidPackageName:package,
          androidMinimumVersion: "1",
        )
    ).then((value){
      print("email sent");
    });
  }

  void handleLink(Uri link,userEmail) async {
    if (link != null) {
      print(userEmail);
      final UserCredential user = await FirebaseAuth.instance.signInWithEmailLink(
        email:userEmail,
        emailLink:link.toString(),
      );
      if (user != null) {
        print(user.credential);
      }
    } else {
      print("link is null");
    }
  }
}