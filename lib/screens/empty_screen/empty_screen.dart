import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../allProviders/DarkThemeProvider.dart';
class EmptyScreen extends StatelessWidget {

  const EmptyScreen({Key? key, required this.image, required this.title, required this.buttonTitle, required this.page, required this.appBarTitle}) : super(key: key);
  final Image image ;
  final String title;
  final String buttonTitle;
  final Widget page;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white54 : Colors.black54;
    var  size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: color,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title:Text(appBarTitle ,style: TextStyle(color: themeState.getDarkTheme ? Colors.white : Colors.black),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: SizedBox(
              width: size.width*0.5,
              child: image
            ),
          ),
          const SizedBox(height: 20,),
           Text(title,style: const TextStyle(fontWeight: FontWeight.bold,
          ),),
          const SizedBox(height: 20,),

          GestureDetector(
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
            },
            child: Container(
              height: 30,
              width: size.width*0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                  color: Colors.blue.withOpacity(0.9)
              ),
              child:  Center(child: Text(buttonTitle,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold
              ),)),
            ),
          )
        ],
      ),
    );
  }
}
