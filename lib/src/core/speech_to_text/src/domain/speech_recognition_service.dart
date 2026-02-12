import 'package:dartz/dartz.dart';

import 'package:spending_pal/src/core/speech_to_text/src/domain/speech_to_text_failure.dart';
import 'package:spending_pal/src/core/speech_to_text/src/domain/speech_to_text_result.dart';

abstract class SpeechRecognitionService {
  Future<Either<SpeechToTextFailure, bool>> initialize();
  Future<Either<SpeechToTextFailure, void>> startListening({
    required Function(SpeechToTextResult) onResult,
  });
  Future<Either<SpeechToTextFailure, void>> stopListening();
  bool get isListening;
  bool get isInitialized;
}
