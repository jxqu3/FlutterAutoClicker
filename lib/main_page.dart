import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_event/keyboard_event.dart';
import 'package:flutter_auto_gui/flutter_auto_gui.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var mouseButton = "1";
  bool start = false;
  bool clicking = false;
  bool waitForKey = false;
  double cps = 1;
  double delay = 0;
  var toggleKey = "RMENU";
  late Timer timer;
  late KeyboardEvent keyboardEvent;

  @override
  void initState() {
    super.initState();
    keyboardEvent = KeyboardEvent();
    try {
      KeyboardEvent.init();
    } on PlatformException {
      throw 'failed to get VK map';
    }
    keyboardEvent.startListening((event) {
      if (event.isKeyUP && event.vkName == toggleKey) {
        setState(() {
          clicking = !clicking;
          if (!start) {
            clicking = false;
          }
        });
      }
      if (event.isKeyUP) {
        setState(() {
          if (waitForKey) {
            toggleKey = event.vkName!;
            waitForKey = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M4teAutoClicker"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Clicks Per Second: ${cps.toStringAsFixed(1)}"),
            Slider(
              value: cps,
              onChanged: (v) => setState(() => cps = v.clamp(1, 100)),
              min: 0.1,
              max: 100,
              divisions: 999,
              label: cps.toStringAsFixed(1),
            ),
            Text("Random Delay: ${delay.toStringAsFixed(1)}ms"),
            Slider(
              value: delay,
              onChanged: (v) => setState(() => delay = v),
              min: 0,
              max: 200,
              divisions: 999,
              label: "${delay.toStringAsFixed(1)}ms",
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      waitForKey = true;
                    });
                  },
                  child: Text(
                      waitForKey ? "Press Any Key" : "Toggle Key: $toggleKey")),
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Mouse Button:"),
                    DropdownButton(
                      value: mouseButton,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(
                          value: "1",
                          child: Text("Left"),
                        ),
                        DropdownMenuItem(
                          value: "2",
                          child: Text("Right"),
                        )
                      ],
                      onChanged: (value) => {
                        setState(() {
                          mouseButton = value!;
                        })
                      },
                    ),
                  ],
                )),
            TextButton(
                onPressed: () async {
                  setState(() {
                    start = !start;
                    if (cps <= 0.1) {
                      cps = 1;
                    }
                    if (start) {
                      Future.doWhile(() async {
                        if (!start) return false;
                        if (clicking) {
                          FlutterAutoGUI.click(
                              button: mouseButton == "1"
                                  ? MouseButton.left
                                  : MouseButton.right);
                        }
                        await Future.delayed(Duration(
                            milliseconds: 1000 ~/ cps +
                                Random().nextInt(delay.toInt() + 1)));
                        return true;
                      });
                    } else {
                      clicking = false;
                    }
                  });
                },
                child: Text(start ? "Stop ($toggleKey To Toggle)" : "Start"))
          ],
        ),
      ),
    );
  }
}
