import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/translation_model.dart';

class TranslationProvider extends ChangeNotifier {
  List<Translation> translations = [];
  String translatedText = '';

  String? sourceLanguage;
  String? targetLanguage;

  Future<void> loadTranslations() async {
    try {
      final String response =
          await rootBundle.loadString('assets/translations.json');
      final List<dynamic> data = jsonDecode(response);
      translations = data.map((json) => Translation.fromJson(json)).toList();
    } catch (e, stacktrace) {
      print('Error loading translations: $e');
      print('Stacktrace: $stacktrace');
    }
    notifyListeners();
  }

  void setSourceLanguage(String language) {
    sourceLanguage = language;
    notifyListeners();
  }

  void setTargetLanguage(String language) {
    targetLanguage = language;
    notifyListeners();
  }

  void translateText(String input) {
    if (sourceLanguage == null || targetLanguage == null) {
      translatedText = 'Please select both source and target languages.';
    } else {
      final translation = translations.firstWhere(
        (t) => t.texts[sourceLanguage]?.toLowerCase() == input.toLowerCase(),
        orElse: () => Translation(id: '', texts: {}, audioFiles: {}),
      );
      translatedText =
          translation.texts[targetLanguage] ?? 'Translation not found';
    }
    notifyListeners();
  }

  List<String> getMatchingSentences(String input) {
    if (sourceLanguage == null) return [];
    return translations
        .map((t) => t.texts[sourceLanguage] ?? '')
        .where((text) => text.toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  String? getAudioFile(String text, String language) {
    final translation = translations.firstWhere(
      (t) => t.texts[language]?.toLowerCase() == text.toLowerCase(),
      orElse: () => Translation(id: '', texts: {}, audioFiles: {}),
    );
    return translation.audioFiles[language];
  }
}
