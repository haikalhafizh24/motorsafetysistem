import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

final Telephony telephony = Telephony.instance;

class MainButton extends StatelessWidget {

  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  const MainButton({
  Key? key,

    required this.logo, 
    required this.title, 
    required this.messageContent, 
    required this.colour,

  }) : super(key: key);

  

  final IconData logo;
  final String title;
  final String messageContent;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Column(
      children: [
        GestureDetector(
          onTap:() async {
              await telephony.sendSms(
	              to: "089528119353",
	              message: messageContent,
              );
                  },
          onTapDown: _tapDown,
          onTapUp: _tapUp,
          child: Transform.scale(
            scale: _scale,
            child: 
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                      height: 20,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
        ],
          );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}