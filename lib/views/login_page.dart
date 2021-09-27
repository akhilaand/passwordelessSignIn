import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:passwordles_sign_in/common/colors.dart';

class LoginPage extends StatefulWidget {
   LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
final TextEditingController _emailController=TextEditingController();

final FirebaseAuth _auth = FirebaseAuth.instance;

   Future signInWithEmailandLink(userEmail)async{
     var _userEmail=userEmail;
     return await _auth.sendSignInLinkToEmail(
         email: _userEmail,
         actionCodeSettings: ActionCodeSettings(
           url: "https://pickwhatevernameyouwant.page.link/",
           handleCodeInApp: true,
           androidPackageName:"com.example.passwordles_sign_in",
           androidMinimumVersion: "1",
         )
     ).then((value){
       print("email sent");
     });
   }
@override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }
   @override
   void didChangeAppLifecycleState(AppLifecycleState state) async {
     try{
       FirebaseDynamicLinks.instance.onLink(
           onSuccess: (PendingDynamicLinkData? dynamicLink) async {
             final Uri? deepLink = dynamicLink?.link;
             if (deepLink != null) {
               print("------------------");
              handleLink(deepLink,_emailController.text);
               FirebaseDynamicLinks.instance.onLink(
                   onSuccess: (PendingDynamicLinkData?dynamicLink) async {
                     final Uri? deepLink = dynamicLink!.link;
                     handleLink(deepLink!,_emailController.text);
                   }, onError: (OnLinkErrorException e) async {
                 print('onLinkError');
                 print(e.message);
               });
               // Navigator.pushNamed(context, deepLink.path);
             }
           },
           onError: (OnLinkErrorException e) async {
             print('onLinkError');
             print(e.message);
           }
       );

       final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
       final Uri? deepLink = data?.link;

       if (deepLink != null) {
         print(deepLink.userInfo);
       }
     }catch(e){
       print(e);
     }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Type in your email address",
                  fillColor: Colors.white70),
              controller: _emailController,
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(onPressed: (){
              signInWithEmailandLink(_emailController.text);
            },
              color: blue,
            child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
