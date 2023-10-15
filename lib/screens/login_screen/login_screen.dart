import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../methods/btm_alert.dart';
import '../../widgets/custom_button.dart';
import '../feeds_screen/featch_screen.dart';
import '../../widgets/social_media_btn.dart';
import '../Buttom_bar_screens/forgot_password.dart';
import '../signup_screen/signup_widget.dart';
import '../../../widgets/custom_text_field.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'login page';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool obscureTextForm = true;
  GlobalKey<FormState> formKey = GlobalKey();

  String? email, password;
  @override
  Widget build(BuildContext context) {
    var  size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      color: Colors.transparent,
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Image.asset(
                  'Assets/login.png',
                  height: size.width*0.5,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                     Text(
                      'Welcome Back !',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                const SizedBox(
                  height: 10,
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
                Padding(
                  padding:  EdgeInsets.only(left: size.width*0.65),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
                    },
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                CustomButon(
                  onTap: () async{
                    setState(() {
                      isLoading = true;
                    });
                    final form = formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      try{
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!.trim(), password: password!);
                        if (context.mounted) Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const fetchScreen()));
                        setState(() {
                          isLoading = false;
                        });
                      }
                      on FirebaseException catch (e) {
                        showBtmAlert(context , e.message.toString());
                        setState(() {
                          isLoading = false;
                        });
                      }catch(error){
                        showBtmAlert(context , error.toString());
                      }finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });                    }
                  },
                  text: 'LOGIN',
                ),
                const SizedBox(
                  height: 10,
                ),
                const SocialMediaBtn(title: 'Sign in with Google',),
                Padding(
                  padding: const EdgeInsets.only(top : 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'create an account?',
                        style: TextStyle(
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignupScreen()));
                        },
                        child: const Text(
                          '  Register',
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
