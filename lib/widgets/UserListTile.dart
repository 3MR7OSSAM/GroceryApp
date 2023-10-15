// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
class UserListTile extends StatelessWidget {
   const UserListTile({Key? key, required this.title,  this.subtitle, required this.icon, required this.onPress, }) : super(key: key);
  final String title;
  final String? subtitle;
  final Icon icon;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
      subtitle:  subtitle !=null ? Text('$subtitle'):null,
      leading: icon,
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: (){
        onPress();
      },
    );
  }
}
