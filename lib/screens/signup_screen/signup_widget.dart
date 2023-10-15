import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../methods/btm_alert.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../widgets/custom_button.dart';
import '../feeds_screen/featch_screen.dart';
import '../../widgets/social_media_btn.dart';
import '../../widgets/custom_text_field.dart';
import '../login_screen/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  static String id = 'Signup page';
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen> {

  bool isLoading = false;
  bool obscureTextForm = true;
  GlobalKey<FormState> formKey = GlobalKey();
  String? email, password,name,address;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Column(
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          'Signup to continue',
                          style: TextStyle(
                              fontSize: 13,
                              color:Colors.amber,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  hasIcon: false,
                  onChanged: (data) {
                    name = data.trim();
                  },
                  validator:(value){
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }return null;
                  } ,
                  hintText: 'Full Name',
                ),
                CustomTextField(
                  hasIcon: false,
                  onChanged: (data) {
                    address = data.trim();
                  },
                  validator:(value){
                    if (value == null || value.isEmpty) {
                      return 'Address is required';
                    }return null;
                  } ,
                  hintText: 'Address',
                ),
                CustomTextField(
                  hasIcon: false,
                  onChanged: (data) {
                    email = data.trim();
                  },
                  validator:(value){
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Invalid email address';
                    }
                    return null;
                  } ,
                  hintText: 'Email',
                ),

                CustomTextField(
                  hasIcon: true,
                  validator:(value){
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password should be at least 6 characters long';
                    }
                    return null;
                  },
                  obscureText: obscureTextForm,
                  onTap: (){
                    setState(() {
                      obscureTextForm = !obscureTextForm;
                    });
                  },
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButon(
                  onTap: ()async {
                    setState(() {
                      isLoading = true;
                    });
                    final form = formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      try{
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!.trim(), password: password!);
                        final User? user  = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
                            {
                              'id':user.uid,
                              'name':name,
                              'email':email,
                              'address':address,
                              'userWishlist':[],
                              'userCart':[],
                              'AccountCreationDate':Timestamp.now(),
                            });
                        if (context.mounted) Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const fetchScreen()));

                        setState(() {
                          isLoading = false;
                        });
                      }on FirebaseException catch (e) {
                        showBtmAlert(context , e.message.toString());
                        setState(() {
                          isLoading = false;
                        });
                      }finally{
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  text: 'Signup',
                ),
                const SizedBox(
                  height: 10,
                ),
                const SocialMediaBtn(title: 'Sign up with Google',),
                Padding(
                  padding: const EdgeInsets.only(top : 16.0,bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'Have an account?',
                        style: TextStyle(
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));

                        },
                        child: const Text(
                          '  Sign in',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
