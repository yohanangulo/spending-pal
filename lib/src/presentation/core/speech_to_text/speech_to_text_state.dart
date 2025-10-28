part of 'speech_to_text_bloc.dart';

@freezed
abstract class SpeechToTextState with _$SpeechToTextState {
  const factory SpeechToTextState({
    @Default(true) bool isInitialized,
    @Default(true) bool isListening,
    @Default('') String recognizedText,
    @Default('') String lastFinalText,
    SpeechToTextFailure? failure,
  }) = _SpeechToTextState;
}
