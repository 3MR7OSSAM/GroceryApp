import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/widgets/product_empty.dart';
import '../../Models/products_model.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/product_provider.dart';
import '../feeds_screen/feeds_widgets.dart';
class CategoryView extends StatefulWidget {
  const CategoryView({Key? key, required this.category}) : super(key: key);
  final String category;
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final FocusNode _searchTextFocusNode = FocusNode();
  final TextEditingController _searchTextController = TextEditingController();
  List<ProductModel> filteredProducts = [];
  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> productsByCategory = productProvider.findByCategory(widget.category);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        centerTitle: true,
        title: Text(
          'All Products',
          style: TextStyle(color: color),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: SizedBox(
                height: screenWidth*0.15,
                child: TextField(
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  onChanged: (value) {
                    setState(() {
                      filteredProducts = productsByCategory
                          .where((product) =>
                          product.title.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1),
                    ),
                    hintText: "What's in your mind",
                    prefixIcon: const Icon(Icons.search),
                    suffix: IconButton(
                      onPressed: () {
                        _searchTextController.clear();
                        _searchTextFocusNode.unfocus();
                        filteredProducts =[];

                      },
                      icon: Icon(
                        Icons.close,
                        color: _searchTextFocusNode.hasFocus ? Colors.blueAccent : color,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            productsByCategory.isEmpty?ProductEmpty(name:widget.category,):
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _searchTextController.text.isEmpty ?
              productsByCategory.length:
              filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChangeNotifierProvider.value(
                      value:  _searchTextController.text.isEmpty ?
                      productsByCategory[index]:
                      filteredProducts[index],
                      child: const FeedsWidget()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
