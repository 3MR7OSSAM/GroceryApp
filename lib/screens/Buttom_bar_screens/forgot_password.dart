import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../../methods/btm_alert.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}
GlobalKey<FormState> formKey = GlobalKey();

class _ForgotPasswordState extends State<ForgotPassword> {

  @override
  Widget build(BuildContext context) {

    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    String? email;
    void sendEmail(String email, context)async{
     try {
       await FirebaseAuth.instance.sendPasswordResetEmail(email: email.toString().trim());
       showBtmAlert(context , 'An Email With password reset Link has been sent to your e-mail');
     }on FirebaseException catch  (e) {
       showBtmAlert(context , e.message.toString());
     }
     catch(e){
       showBtmAlert(context , e.toString());
     }
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 20,),
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
                hintText: 'Email address',
              ),
              const SizedBox(height: 10,),
              Center(
                child: CustomButon(
                  onTap: () {

                    final form = formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      sendEmail(email.toString().trim(),context);
                    } else {
                    }
                  },
                  text: 'Reset Now',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
