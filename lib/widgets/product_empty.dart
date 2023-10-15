import 'package:flutter/material.dart';
class ProductEmpty extends StatelessWidget {
  const ProductEmpty({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('out supply of $name is not available yet'),
    );
  }
}
