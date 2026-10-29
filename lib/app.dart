import 'package:flutter/material.dart';

import 'features/record/record_page.dart';

class VelaApp extends StatelessWidget {
  const VelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vela 60F',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
        useMaterial3: true,
      ),
      home: const RecordPage(),
    );
  }
}
