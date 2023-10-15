import 'package:flutter/material.dart';
class QuantityWidget extends StatelessWidget {
  const QuantityWidget({Key? key, required this.icon, required this.onTap, required this.color}) : super(key: key);
final IconData icon ;
final Function onTap;
final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: (){
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Center(child: Icon(icon,color: Colors.white,)),
      ),
    );
  }
}
