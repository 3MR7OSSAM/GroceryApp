import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/Models/products_model.dart';
import 'package:GroceryApp/allProviders/product_provider.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../feeds_screen/feeds_widgets.dart';
import '../onSale_screen/on_sala_widget.dart';
import 'feeds_screen.dart';
import '../onSale_screen/on_sale_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final List<String> _offerImages = [
    'Assets/offres/Offer1.jpg',
    'Assets/offres/Offer2.jpeg',
    'Assets/offres/Offer3.jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> products = productProvider.getProducts;
    List<ProductModel> onSaleProducts = productProvider.onSale;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title:Text('Home' ,style: TextStyle(color: themeState.getDarkTheme ? Colors.white : Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(bottom: screenHeight*.02),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * .2,
                child: Swiper(
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      _offerImages[index],
                      fit: BoxFit.fitWidth,
                    );
                  },
                  itemCount: _offerImages.length,
                  pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                          activeColor: Colors.black38
                      )
                  ),
                ),
              ),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const onSaleScreen()));
              },
                child: const Text('View all', style: TextStyle(fontSize: 18),),),

              Row(
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.discount_outlined, color: color, size: 20,),
                        Text('On Sale'.toUpperCase(),
                          style: TextStyle(color: color, fontSize: 20),),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: screenHeight * 0.20,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: onSaleProducts.length >=6 ? 6 : onSaleProducts.length ,
                          itemBuilder: (context, index) {
                            return  ChangeNotifierProvider.value(
                                value: onSaleProducts[index],
                                child: const OnSale());
                          }),
                    ),
                  ),
                ],
              ),

              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Our Products', style: TextStyle(color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),),
                      const Spacer(),
                      TextButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedScreen()));
                      }, child: const Text('Browse all')),
                    ],
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length >= 6 ? 6 : products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                ),
                itemBuilder:(context,index){
                  return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChangeNotifierProvider.value(
                        value: products[index],
                        child: const FeedsWidget(),),
                  );
                },)
            ],
          ),
        ),
      ),
    );
  }
}
