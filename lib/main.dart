import 'package:flutter/material.dart';

import 'app/pages/app_home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HelpDeskLiteApp());
}

class HelpDeskLiteApp extends StatelessWidget {
  const HelpDeskLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResolveTI',
      theme: AppTheme.light(),
      home: const AppHomePage(),
    );
  }
}
