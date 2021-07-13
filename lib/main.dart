import 'package:flutter/material.dart';
import 'screen/map_screen.dart';
import 'screen/control_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ControlScreen.id,
      routes: {
        ControlScreen.id: (context) => ControlScreen(),
        MapScreen.id: (context) => MapScreen(),
      },
    );
  }
}
