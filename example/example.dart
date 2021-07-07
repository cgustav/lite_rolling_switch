import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Examples',
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //By default
            LiteRollingSwitch(
              value: false,
              onChanged: (bool state) {
                print('turned ${(state) ? 'on' : 'off'}');
              },
            ),

            //Customized
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: LiteRollingSwitch(
                value: true,
                textOn: 'active',
                textOff: 'inactive',
                colorOn: Colors.deepOrange,
                colorOff: Colors.blueGrey,
                iconOn: Icons.lightbulb_outline,
                iconOff: Icons.power_settings_new,
                onChanged: (bool state) {
                  print('turned ${(state) ? 'on' : 'off'}');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
