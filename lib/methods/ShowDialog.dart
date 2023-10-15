import 'package:flutter/material.dart';

Future<void> showLogoutDialog(BuildContext context,String title,String message,Function? onTap) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel',style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 18
              )
              ),),
              TextButton(onPressed: (){
                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
              }, child: InkWell(
                onTap: (){
                  onTap!();
                },
                child: const Text('Yes',style: TextStyle(
                    color: Colors.red,
                    fontSize: 18
                )
                ),
              ),),

            ],
            content: Text(message),
            title: Row(
              children: [
                const Image(image: AssetImage('Assets/warning-sign.png'),height: 20,width: 20,fit: BoxFit.fill,),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child:  Text(title),
                ),

              ],

            ));

      });
}
