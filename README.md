# African Translator App 🗣️🌍

This **African Translator App** is a Flutter-based application that allows users to translate text between various African languages, including **English**, **Kavango**, **Oshiwambo**, **Herero**, and **Damara**. It also offers audio playback for both input and translated text.

---

## Features 🚀

- **Language Selection**: Switch between five supported languages.
- **Autocomplete Input**: Get translation suggestions as you type.
- **Text-to-Speech Audio Playback**: Listen to both the input and translated text.
- **State Management**: Uses `Provider` to manage the app state.
- **Audio Handling**: Powered by `just_audio` for seamless audio playback.

---

## Technologies Used 🛠️

- **Flutter**: Framework for building the app.
- **Provider**: State management.
- **just_audio**: Audio player for text-to-speech.
  
---

## Setup Instructions 📝

Follow these steps to run the project locally:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/Mindsinaction-ICT/namibian_language_translator_app.git
   cd african-translator
   ```

2. **Install Dependencies: Ensure you have Flutter installed. Run:**

   ```bash
   flutter pub get
   ```

3. **Run the App: Connect a device or start an emulator, then:**

   ```bash
   flutter run
   ```

---

## Project Structure 📂

- `lib/screens/home_screen.dart`:  Contains the UI logic for the home screen.
- `lib/providers/translation_provider.dart`:  Manages translations, audio files, and state.
- `assets/`:  Store audio files.
  
---

## How to Use 🧑‍💻

1. **Select Languages:**
Use the dropdowns to select the source and target languages

2. **Enter or Select Text:**
Use the autocomplete text field to enter text or choose from suggestions.

3. **Listen to Translations:**
Press the speaker icon to hear the input or translated text.

---

## Dependencies 📦

- `flutter`
- `provider`
- `just_audio`

Add them using:

   ```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  just_audio: ^0.9.26
```

---

## Contribution Guidelines 🤝

Feel free to open issues or submit pull requests to improve the app. Before contributing, please:

1. Fork the repository.
2. Create a new branch for your feature or bug fix:

   ```bash
   git checkout -b feature/my-feature
   ```

3. Commit your changes and push:

   ```bash
   git commit -m "Added new feature"
   git push origin feature/my-feature
   ```

---

## License 📝

This project is open source and available under the MIT License.

---
## Contact 📧

For any inquiries or support, reach out at:

- **Email:** shain@mindsinaction.com.na
- **GitHub:** shecode-hue

---

## Acknowledgments 🙌

Special thanks to all contributors and open-source maintainers for their support!

---
