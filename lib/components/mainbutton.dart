import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

final Telephony telephony = Telephony.instance;

class MainButton extends StatelessWidget {

  const MainButton({
  Key? key,

    required this.logo, 
    required this.title, 
    required this.colour,
    required this.bgColour,
    required this.txtColour,
    required this.height,
    required this.width

  }) : super(key: key);

  final IconData logo;
  final String title;
  final Color colour;
  final double height;
  final double width;
  final Color bgColour;
  final Color txtColour;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: bgColour,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [ BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(5,5),
                  ),
                ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      logo,
                      size:45,
                      color: colour,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: txtColour,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
            ),
        // ),
      ],
    );
  }
}