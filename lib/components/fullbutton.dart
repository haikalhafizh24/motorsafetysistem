import 'package:flutter/material.dart';

class FullButton extends StatelessWidget {
  const FullButton({
    Key? key,
    required this.size, 
    required this.boxheight, 
    required this.fillColor, 
    required this.name,

  }) : super(key: key);

  final Size size;
  final Color fillColor;
  final String name;
  final double boxheight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxheight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600
          ),
          ),
      ),
    );
  }
}