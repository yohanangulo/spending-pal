import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:spending_pal/src/core/speech_to_text/src/domain/speech_recognition_service.dart';
import 'package:spending_pal/src/core/speech_to_text/src/domain/speech_to_text_failure.dart';
import 'package:spending_pal/src/core/speech_to_text/src/domain/speech_to_text_result.dart';

@Singleton(as: SpeechRecognitionService)
class SpeechRecognitionServiceImpl implements SpeechRecognitionService {
  const SpeechRecognitionServiceImpl(this._speechToText);

  final SpeechToText _speechToText;

  @override
  bool get isListening => _speechToText.isListening;

  @override
  bool get isInitialized => _speechToText.isAvailable;

  @postConstruct
  @override
  Future<Either<SpeechToTextFailure, bool>> initialize() async {
    try {
      final bool available = await _speechToText.initialize(
        debugLogging: true,
        onStatus: (status) => log('Speech recognition status: $status'),
        onError: (error) => log('Speech recognition error: $error'),
      );

      if (!available) {
        return left(const SpeechToTextFailure.notSupported());
      }

      return right(available);
    } catch (e) {
      return left(const SpeechToTextFailure.unknown());
    }
  }

  @override
  Future<Either<SpeechToTextFailure, Unit>> startListening({
    required Function(SpeechToTextResult) onResult,
  }) async {
    try {
      if (!_speechToText.isAvailable) {
        return left(const SpeechToTextFailure.notInitialized());
      }

      log('Speech recognition started 🚀');

      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          log('Speech recognition result: ${result.recognizedWords}');
          final speechResult = SpeechToTextResult(
            recognizedWords: result.recognizedWords,
            finalResult: result.finalResult,
            confidence: result.confidence,
          );
          onResult(speechResult);
        },
      );

      return right(unit);
    } catch (e) {
      return left(const SpeechToTextFailure.unknown());
    }
  }

  @override
  Future<Either<SpeechToTextFailure, Unit>> stopListening() async {
    try {
      log('Speech recognition stopped 🛑');

      unawaited(_speechToText.stop());

      return right(unit);
    } catch (e) {
      return left(const SpeechToTextFailure.unknown());
    }
  }
}
