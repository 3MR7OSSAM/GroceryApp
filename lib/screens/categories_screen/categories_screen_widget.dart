import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../allProviders/DarkThemeProvider.dart';
import 'category_view_screen.dart';
class CategoriesWidgets extends StatelessWidget {
  const CategoriesWidgets({Key? key, required this.name, required this.image,}) : super(key: key);
  final String name;
  final String image;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryView(category: name ,)));
      },
      child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                height: screenWidth *0.25,
                width:  screenWidth *0.25,
                decoration: BoxDecoration(
                  boxShadow:  [
                        const BoxShadow(
                            color: Colors.blueAccent,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(4,4)
                        ), BoxShadow(
                        color: Theme.of(context).cardColor,
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(4,4)
                    ) ,BoxShadow(
                        color: Colors.blueAccent.shade100,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(-4,-4)
                    )

                  ],
                    image: DecorationImage(image: AssetImage(image),fit: BoxFit.fitWidth),
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).cardColor

                ),
              ),
              Text(name,style: TextStyle(color: color,fontSize: 20,fontWeight: FontWeight.bold),)
            ],

    ));
  }
}
