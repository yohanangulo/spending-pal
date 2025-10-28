part of 'speech_to_text_bloc.dart';

@freezed
abstract class SpeechToTextEvent with _$SpeechToTextEvent {
  factory SpeechToTextEvent.onStarted() = SpeechToTextStarted;
  factory SpeechToTextEvent.onStartedListening() = SpeechToTextStartedListening;
  factory SpeechToTextEvent.onStoppedListening() = SpeechToTextStoppedListening;
  factory SpeechToTextEvent.onResultReceived(SpeechToTextResult result) = SpeechToTextResultReceived;
  factory SpeechToTextEvent.onTextCleared() = SpeechToTextTextCleared;
}
