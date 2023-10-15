import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../methods/btm_alert.dart';
import '../btm_bar_screen.dart';
import '../screens/feeds_screen/featch_screen.dart';

class SocialMediaBtn extends StatelessWidget {
  final String title;

  const SocialMediaBtn({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void googleSignIn(context) async {
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          try {
            final authResult = await FirebaseAuth.instance
                .signInWithCredential(GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ));
            if (authResult.additionalUserInfo!.isNewUser) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(authResult.user!.uid)
                  .set({
                'id': authResult.user!.uid,
                'name': authResult.user!.displayName,
                'email': authResult.user!.email,
                'address': 'Add Your Address',
                'userWishlist': [],
                'userCart': [],
                'AccountCreationDate': Timestamp.now(),
              });
            }
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const fetchScreen()));
          } on FirebaseException catch (e) {
            showBtmAlert(context, e.message.toString());
          } catch (error) {
            showBtmAlert(context, error.toString());
          }
        }
      }
    }
    return InkWell(
      onTap: () {
        googleSignIn(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(16)),
        width: 30,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('Assets/google.png'),
            ),
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).unselectedWidgetColor,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
