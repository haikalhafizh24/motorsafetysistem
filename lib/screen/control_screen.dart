import 'dart:async';
import 'package:flutter/material.dart';
import 'package:motorsafetysistem/screen/locationData_screen.dart';
import 'package:motorsafetysistem/components/mainbutton.dart';
import 'package:motorsafetysistem/components/fullbutton.dart';
import 'package:telephony/telephony.dart';
import 'package:motorsafetysistem/services/shared_preferences.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

final Telephony telephony = Telephony.instance;

class ControlScreen extends StatefulWidget {
  static const String id = 'control_screen';
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen>
    with TickerProviderStateMixin {
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  String number = '';

  late double _scale1;
  late AnimationController _controller1;
  late double _scale2;
  late AnimationController _controller2;
  late double _scale3;
  late AnimationController _controller3;
  late double _scale4;
  late AnimationController _controller4;
  late double _scale5;
  late AnimationController _controller5;

  @override
  void initState() {
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _controller3 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _controller4 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _controller5 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    super.initState();

    number = PhoneNumberPreferences.getNumberPhone() ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
  }

  void sms(String messageContent) async {
    if (number == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Masukkan Nomor tujuan',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      await telephony.sendSms(to: number, message: messageContent);
    }
  }

  void savenumber(RoundedLoadingButtonController controller) async {
    await PhoneNumberPreferences.setNumberPhone(number);
    Timer(Duration(seconds: 1), () {
      controller.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    _scale1 = 1 - _controller1.value;
    _scale2 = 1 - _controller2.value;
    _scale3 = 1 - _controller3.value;
    _scale4 = 1 - _controller4.value;
    _scale5 = 1 - _controller5.value;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            margin: EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sistem Pengaman",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Sepeda Motor",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1F487E),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: IconButton(
                    splashRadius: 32,
                    highlightColor: Color(0xFF1F487E),
                    icon: Icon(Icons.call),
                    color: Colors.white,
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                          ),
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Masukkan Nomor Telepon",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      TextFormField(
                                        keyboardType: TextInputType.phone,
                                        initialValue: number,
                                        textAlign: TextAlign.center,
                                        onChanged: (number) {
                                          setState(() {
                                            this.number = number;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: "+62...",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueAccent,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueAccent,
                                                  width: 3.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0))),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      RoundedLoadingButton(
                                          width: size.width * 0.9,
                                          color: Colors.blueAccent,
                                          borderRadius: 20,
                                          controller: _buttonController,
                                          valueColor: Colors.white,
                                          onPressed: () {
                                            savenumber(_buttonController);
                                          },
                                          child: Text(
                                            "Simpan",
                                            style: TextStyle(fontSize: 18.0),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  sms("MODUL HIDUP");
                },
                onTapDown: _tapDown1,
                onTapUp: _tapUp1,
                child: Transform.scale(
                  scale: _scale1,
                  child: MainButton(
                    height: size.width * 0.4,
                    width: size.width * 0.4,
                    bgColour: Colors.white,
                    txtColour: Colors.black,
                    logo: Icons.power_settings_new_rounded,
                    title: "Modul ON",
                    colour: Color(0xFF1F487E),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  sms("MODUL MATI");
                },
                onTapDown: _tapDown2,
                onTapUp: _tapUp2,
                child: Transform.scale(
                  scale: _scale2,
                  child: MainButton(
                      height: size.width * 0.4,
                      width: size.width * 0.4,
                      bgColour: Colors.white,
                      txtColour: Colors.black,
                      logo: Icons.power_settings_new_rounded,
                      title: "Modul OFF",
                      colour: Colors.red),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  sms("KONTAK ON");
                },
                onTapDown: _tapDown3,
                onTapUp: _tapUp3,
                child: Transform.scale(
                  scale: _scale3,
                  child: MainButton(
                    height: size.width * 0.4,
                    width: size.width * 0.4,
                    bgColour: Colors.white,
                      txtColour: Colors.black,
                    logo: Icons.vpn_key_sharp,
                    title: "Kontak ON",
                    colour: Color(0xFF1F487E),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  sms("KONTAK OFF");
                },
                onTapDown: _tapDown4,
                onTapUp: _tapUp4,
                child: Transform.scale(
                  scale: _scale4,
                  child: MainButton(
                    height: size.width * 0.4,
                    width: size.width * 0.4,
                    bgColour: Colors.white,
                      txtColour: Colors.black,
                    logo: Icons.vpn_key_sharp,
                    title: "Kontak OFF",
                    colour: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  sms("STATER ON");
                },
                onTapDown: _tapDown5,
                onTapUp: _tapUp5,
                child: Transform.scale(
                  scale: _scale5,
                  child: MainButton(
                      height: size.width * 0.35,
                      width:size.width * 0.85,
                      bgColour: Color(0xFF1F487E),
                      txtColour: Colors.white,
                      logo: Icons.electric_moped_rounded,
                      title: "Stater",
                      colour: Colors.white),
                ),
              ),
            ],
          ),
          Container(
            padding:EdgeInsets.symmetric(vertical: 15),
            child: GestureDetector(
              onTap: () async {
                Navigator.pushNamed(context, Locationdatascreen.id);
                sms("GPS ON");
              },
              child: FullButton(
                boxheight: 50,
                fillColor: Colors.blueAccent,
                name: "Dapatkan Lokasi",
                size: size,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _tapDown1(TapDownDetails details) {
    _controller1.forward();
  }

  void _tapUp1(TapUpDetails details) {
    _controller1.reverse();
  }

  void _tapDown2(TapDownDetails details) {
    _controller2.forward();
  }

  void _tapUp2(TapUpDetails details) {
    _controller2.reverse();
  }

  void _tapDown3(TapDownDetails details) {
    _controller3.forward();
  }

  void _tapUp3(TapUpDetails details) {
    _controller3.reverse();
  }

  void _tapDown4(TapDownDetails details) {
    _controller4.forward();
  }

  void _tapUp4(TapUpDetails details) {
    _controller4.reverse();
  }

  void _tapDown5(TapDownDetails details) {
    _controller5.forward();
  }

  void _tapUp5(TapUpDetails details) {
    _controller5.reverse();
  }
}
