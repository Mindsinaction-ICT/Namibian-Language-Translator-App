import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/translation_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final translationProvider = TranslationProvider();
  await translationProvider.loadTranslations();

  runApp(
    ChangeNotifierProvider<TranslationProvider>(
      create: (context) => translationProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'African Language Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
