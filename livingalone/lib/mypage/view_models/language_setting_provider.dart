import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageSettingProvider = StateNotifierProvider<LanguageSettingNotifier, String>((ref) {
  return LanguageSettingNotifier();
});

class LanguageSettingNotifier extends StateNotifier<String> {
  LanguageSettingNotifier() : super('한국어');

  void setLanguage(String language) {
    state = language;
  }
}