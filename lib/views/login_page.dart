import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:passwordles_sign_in/common/colors.dart';
import 'package:passwordles_sign_in/services/passwordless_login_services.dart';

class LoginPage extends StatefulWidget {
   LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
final TextEditingController _emailController=TextEditingController();
PasswordlessLoginServices _passwordlessLoginServices=PasswordlessLoginServices();



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
              _passwordlessLoginServices.handleLink(deepLink,_emailController.text);
               FirebaseDynamicLinks.instance.onLink(
                   onSuccess: (PendingDynamicLinkData?dynamicLink) async {
                     final Uri? deepLink = dynamicLink!.link;
                     _passwordlessLoginServices.handleLink(deepLink!,_emailController.text);
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
              _passwordlessLoginServices.signInWithEmailandLink(_emailController.text);
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
