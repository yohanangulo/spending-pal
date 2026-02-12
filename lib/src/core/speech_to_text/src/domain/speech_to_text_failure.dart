import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_to_text_failure.freezed.dart';

@freezed
abstract class SpeechToTextFailure with _$SpeechToTextFailure {
  const factory SpeechToTextFailure.notSupported() = _NotSupported;
  const factory SpeechToTextFailure.notInitialized() = _NotInitialized;
  const factory SpeechToTextFailure.permissionDenied() = _PermissionDenied;
  const factory SpeechToTextFailure.listeningNotStarted() = _ListeningNotStarted;
  const factory SpeechToTextFailure.unknown() = _Unknown;
}
