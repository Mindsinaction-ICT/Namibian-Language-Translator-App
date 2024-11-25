import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/translation_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> languages = [
    'english',
    'kavango',
    'oshiwambo',
    'herero',
    'damara'
  ];

  final TextEditingController inputController = TextEditingController();
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    inputController.dispose();
    super.dispose();
  }

  void clearAll(TranslationProvider provider) {
    inputController.clear();
    provider.clearTranslation();
  }

  Future<void> playAudio(String? audioFile) async {
    if (audioFile != null) {
      try {
        await player.setAsset(audioFile);
        await player.play();
      } catch (e) {
        print('Error playing audio: $e');
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing audio. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranslationProvider>();
    final selectedSourceLang = provider.sourceLanguage;
    final selectedTargetLang = provider.targetLanguage;
    final translations = provider.getMatchingSentences(inputController.text);
    final translatedText = provider.translatedText;

    return Scaffold(
      body: Container(
        color: Color(0xFFFFF7ED), // orange-50
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'African Language Translator',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C2D12), // amber-900
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Bridge cultures through conversation',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFB45309), // amber-700
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Language Selection Cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return constraints.maxWidth > 600
                          ? Row(
                              children: [
                                Expanded(
                                    child: _buildSourceLanguageCard(
                                        selectedSourceLang, provider)),
                                SizedBox(width: 16),
                                Expanded(
                                    child: _buildTargetLanguageCard(
                                        selectedTargetLang, provider)),
                              ],
                            )
                          : Column(
                              children: [
                                _buildSourceLanguageCard(
                                    selectedSourceLang, provider),
                                SizedBox(height: 16),
                                _buildTargetLanguageCard(
                                    selectedTargetLang, provider),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: 32),

                  // Translation Area
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return constraints.maxWidth > 600
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildInputSection(
                                    context,
                                    provider,
                                    translations,
                                    selectedSourceLang,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildOutputSection(
                                    translatedText,
                                    selectedTargetLang,
                                    provider,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildInputSection(
                                  context,
                                  provider,
                                  translations,
                                  selectedSourceLang,
                                ),
                                SizedBox(height: 16),
                                _buildOutputSection(
                                  translatedText,
                                  selectedTargetLang,
                                  provider,
                                ),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceLanguageCard(
      String? selectedLang, TranslationProvider provider) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFFDE68A), width: 2), // amber-200
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translate From',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C2D12), // amber-900
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFDE68A), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLang,
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  hint: Text('Select language'),
                  items: languages.map((String lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (String? newLang) {
                    if (newLang != null) provider.setSourceLanguage(newLang);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetLanguageCard(
      String? selectedLang, TranslationProvider provider) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFFDE68A), width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translate To',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C2D12),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFDE68A), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLang,
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  hint: Text('Select language'),
                  items: languages.map((String lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (String? newLang) {
                    if (newLang != null) provider.setTargetLanguage(newLang);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(
    BuildContext context,
    TranslationProvider provider,
    List<String> translations,
    String? selectedSourceLang,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFDE68A), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Autocomplete<String>(
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
                  inputController.text = controller.text;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter text to translate...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up, color: Color(0xFFB45309)),
                  onPressed: () {
                    final audioFile = provider.getAudioFile(
                        inputController.text, selectedSourceLang ?? '');
                    playAudio(audioFile);
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () => provider.translateText(inputController.text),
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Translate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputSection(
    String translatedText,
    String? selectedTargetLang,
    TranslationProvider provider,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              height: 128,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFFBEB),
                border: Border.all(color: Color(0xFFFDE68A), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                translatedText.isEmpty
                    ? 'Translation will appear here'
                    : translatedText,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up, color: Color(0xFFB45309)),
                  onPressed: () {
                    final audioFile = provider.getAudioFile(
                        translatedText, selectedTargetLang ?? '');
                    playAudio(audioFile);
                  },
                ),
                   IconButton(
                  icon: Icon(Icons.refresh, color: Color(0xFFB45309)),
                  onPressed: () => clearAll(provider),
                  tooltip: 'Clear all',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
