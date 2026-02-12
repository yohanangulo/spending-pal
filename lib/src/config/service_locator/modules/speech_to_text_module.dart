import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';

@module
abstract class SpeechToTextModule {
  @lazySingleton
  SpeechToText get speechToText => SpeechToText();
}
