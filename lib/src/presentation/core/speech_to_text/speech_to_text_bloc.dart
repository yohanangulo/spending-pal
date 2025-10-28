import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:spending_pal/src/core/speech_to_text/domain.dart';

part 'speech_to_text_event.dart';
part 'speech_to_text_state.dart';
part 'speech_to_text_bloc.freezed.dart';

@injectable
class SpeechToTextBloc extends Bloc<SpeechToTextEvent, SpeechToTextState> {
  SpeechToTextBloc(this._speechRecognitionService) : super(const SpeechToTextState()) {
    on<SpeechToTextStarted>(_onStarted);
    on<SpeechToTextStartedListening>(_onStartedListening);
    on<SpeechToTextStoppedListening>(_onStoppedListening);
    on<SpeechToTextResultReceived>(_onResultReceived);
    on<SpeechToTextTextCleared>(_onTextCleared);
  }

  final SpeechRecognitionService _speechRecognitionService;

  Future<void> _onStarted(
    SpeechToTextStarted event,
    Emitter<SpeechToTextState> emit,
  ) async {
    final result = await _speechRecognitionService.initialize();
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (success) => emit(state.copyWith(isInitialized: success, failure: null)),
    );
  }

  Future<void> _onStartedListening(
    SpeechToTextStartedListening event,
    Emitter<SpeechToTextState> emit,
  ) async {
    if (!state.isInitialized) {
      return emit(state.copyWith(failure: const SpeechToTextFailure.notInitialized()));
    }

    emit(state.copyWith(isListening: true, failure: null));

    final result = await _speechRecognitionService.startListening(
      onResult: (speechResult) => add(SpeechToTextResultReceived(speechResult)),
    );

    result.fold(
      (failure) => emit(state.copyWith(isListening: false, failure: failure)),
      (_) => {},
    );
  }

  Future<void> _onStoppedListening(
    SpeechToTextStoppedListening event,
    Emitter<SpeechToTextState> emit,
  ) async {
    final result = await _speechRecognitionService.stopListening();
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) => emit(state.copyWith(isListening: false)),
    );
  }

  void _onResultReceived(
    SpeechToTextResultReceived event,
    Emitter<SpeechToTextState> emit,
  ) {
    emit(
      state.copyWith(
        recognizedText: event.result.recognizedWords,
        lastFinalText: event.result.finalResult ? event.result.recognizedWords : state.lastFinalText,
      ),
    );
  }

  void _onTextCleared(
    SpeechToTextTextCleared event,
    Emitter<SpeechToTextState> emit,
  ) {
    emit(state.copyWith(recognizedText: '', lastFinalText: ''));
  }

  @override
  Future<void> close() {
    add(SpeechToTextStoppedListening());
    return super.close();
  }
}
