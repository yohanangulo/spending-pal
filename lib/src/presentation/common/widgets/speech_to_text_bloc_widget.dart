import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';

import 'package:spending_pal/src/core/speech_to_text/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/corners.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/core/speech_to_text/speech_to_text_bloc.dart';

class SpeechToTextBlocWidget extends StatefulWidget {
  const SpeechToTextBlocWidget({
    super.key,
    this.onFinalResult,
    this.hintText,
  });

  final void Function(String)? onFinalResult;
  final String? hintText;

  @override
  State<SpeechToTextBlocWidget> createState() => _SpeechToTextBlocWidgetState();
}

class _SpeechToTextBlocWidgetState extends State<SpeechToTextBlocWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 230),
    );
    _animation = ColorTween(
      end: AppColors.primary,
      begin: Colors.red,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  String _getStatusText(SpeechToTextState state) {
    if (!state.isInitialized) {
      return 'Toca para inicializar reconocimiento de voz';
    }
    if (state.isListening) {
      return 'Escuchando...';
    }

    return widget.hintText ?? 'Toca el micrófono para hablar';
  }

  String _getFailureMessage(SpeechToTextFailure failure) {
    return failure.when(
      notSupported: () => 'Reconocimiento de voz no soportado',
      notInitialized: () => 'Reconocimiento de voz no inicializado',
      permissionDenied: () => 'Permisos de micrófono denegados',
      listeningNotStarted: () => 'No se pudo iniciar la escucha',
      unknown: () => 'Ha ocurrido un error',
    );
  }

  void _onPressed({
    required bool isListening,
    required bool isInitialized,
    required SpeechToTextBloc bloc,
  }) {
    if (!isInitialized) {
      return bloc.add(SpeechToTextStarted());
    }

    if (isListening) {
      return bloc.add(SpeechToTextStoppedListening());
    }

    bloc.add(SpeechToTextStartedListening());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SpeechToTextBloc>();
    final theme = context.theme;
    return MultiBlocListener(
      listeners: [
        BlocListener<SpeechToTextBloc, SpeechToTextState>(
          listenWhen: (previous, current) => previous.isListening != current.isListening,
          listener: (context, state) => _animationController.toggle(),
        ),
        BlocListener<SpeechToTextBloc, SpeechToTextState>(
          listener: (context, state) {
            if (state.failure != null) {
              context.showSnackBar(
                SnackBar(
                  content: Text(_getFailureMessage(state.failure!)),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state.lastFinalText.isNotEmpty && widget.onFinalResult != null) {
              widget.onFinalResult!(state.lastFinalText);
            }
          },
        ),
      ],
      child: BlocBuilder<SpeechToTextBloc, SpeechToTextState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                child: Column(
                  children: [
                    if (state.recognizedText.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(Dimens.p3).copyWith(
                          bottom: Dimens.p10,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: Corners.circular8,
                        ),
                        child: Text(
                          '“${state.recognizedText}”',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Text(
                _getStatusText(state),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimens.p4),
              Center(
                child: _RecordButton(
                  isListening: state.isListening,
                  animation: _animation,
                  onPressed: () => _onPressed(
                    isListening: state.isListening,
                    isInitialized: state.isInitialized,
                    bloc: bloc,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton({
    required this.isListening,
    required this.animation,
    this.onPressed,
  });

  final VoidCallback? onPressed;
  final Animation<Color?> animation;
  final bool isListening;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return AnimatedBuilder(
      animation: animation,
      child: Icon(
        isListening ? Icons.mic : Icons.mic_none,
        color: isListening ? Colors.white : theme.colorScheme.onPrimary,
      ),
      builder: (context, child) => FloatingActionButton.large(
        shape: const CircleBorder(),
        onPressed: onPressed,
        backgroundColor: animation.value,
        child: child,
      ),
    );
  }
}
