import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_to_text_result.freezed.dart';

@freezed
abstract class SpeechToTextResult with _$SpeechToTextResult {
  const factory SpeechToTextResult({
    required String recognizedWords,
    required bool finalResult,
    required double confidence,
  }) = _SpeechToTextResult;
}
