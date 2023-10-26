import 'package:flutter/material.dart';
import 'package:autoclicker/Main_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 600),
    center: true,
    backgroundColor: Colors.transparent,
    title: "M4te AutoClicker",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          sliderTheme: const SliderThemeData()
              .copyWith(showValueIndicator: ShowValueIndicator.always),
          colorScheme: ThemeData.dark(useMaterial3: true).colorScheme.copyWith(
                background: const Color(0xff222222),
              ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0x5549454f)))),
      themeMode: ThemeMode.dark,
      home: const MainPage(),
    );
  }
}
