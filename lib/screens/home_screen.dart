import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/translation_provider.dart';

class HomeScreen extends StatelessWidget {
  final List<String> languages = [
    'english',
    'kavango',
    'oshiwambo',
    'herero',
    'damara'
  ];

  final TextEditingController inputController = TextEditingController();
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranslationProvider>();
    final selectedSourceLang = provider.sourceLanguage;
    final selectedTargetLang = provider.targetLanguage;
    final translations = provider.getMatchingSentences(inputController.text);
    final translatedText = provider.translatedText;

    return Scaffold(
      appBar: AppBar(
        title: const Text('African Language Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection Row
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedSourceLang,
                    hint: const Text('Translate From'),
                    icon: const Icon(Icons.language),
                    onChanged: (String? newLang) {
                      if (newLang != null) provider.setSourceLanguage(newLang);
                    },
                    items: languages.map((String lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedTargetLang,
                    hint: const Text('Translate To'),
                    icon: const Icon(Icons.translate),
                    onChanged: (String? newLang) {
                      if (newLang != null) provider.setTargetLanguage(newLang);
                    },
                    items: languages.map((String lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return translations.where((sentence) => sentence
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                inputController.text = selection;
                provider.translateText(selection);
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                inputController.text =
                    controller.text; 
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Enter or select text',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

          
            Row(
              children: [
                Expanded(
                  child: Text(
                    inputController.text.isEmpty
                        ? 'Enter text to translate'
                        : inputController.text,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () async {
                    final audioFile = provider.getAudioFile(
                        inputController.text, selectedSourceLang ?? '');
                    if (audioFile != null) {
                      await player.setAsset(audioFile);
                      player.play();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

           
            Row(
              children: [
                Expanded(
                  child: Text(
                    translatedText.isEmpty
                        ? 'Translation will appear here'
                        : translatedText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () async {
                    final audioFile = provider.getAudioFile(
                        translatedText, selectedTargetLang ?? '');
                    if (audioFile != null) {
                      await player.setAsset(audioFile);
                      player.play();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
