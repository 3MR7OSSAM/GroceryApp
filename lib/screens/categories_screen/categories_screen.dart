import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/categories_model.dart';
import '../../allProviders/DarkThemeProvider.dart';
import 'categories_screen_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Category',
            style: TextStyle(
                color: themeState.getDarkTheme ? Colors.white : Colors.black),
          ),
        ),
        body: GridView.builder(
            itemCount: categoriesList.length,
            gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1),
            itemBuilder: (context, index) {
              return CategoriesWidgets(
                name: categoriesList[index].name,
                image: categoriesList[index].image,
              );
            }));
  }
}
