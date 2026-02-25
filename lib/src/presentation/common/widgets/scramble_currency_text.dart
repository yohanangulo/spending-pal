import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScrambleCurrencyText extends StatefulWidget {
  const ScrambleCurrencyText({
    required this.targetAmount,
    required this.isReady,
    this.style,
    this.currencySymbol = r'$',
    this.scrambleDuration = const Duration(milliseconds: 50),
    this.countUpDuration = const Duration(milliseconds: 800),
    this.countUpCurve = Curves.easeOutCubic,
    super.key,
  });

  final double targetAmount;
  final bool isReady;
  final TextStyle? style;
  final String currencySymbol;
  final Duration scrambleDuration;
  final Duration countUpDuration;
  final Curve countUpCurve;

  @override
  State<ScrambleCurrencyText> createState() => _ScrambleCurrencyTextState();
}

class _ScrambleCurrencyTextState extends State<ScrambleCurrencyText> with SingleTickerProviderStateMixin {
  final _random = Random();
  Timer? _scrambleTimer;
  late final AnimationController _countUpController;

  String _displayText = '';
  bool _hasCompletedCountUp = false;
  bool _wasReady = false;

  @override
  void initState() {
    super.initState();
    _countUpController = AnimationController(
      vsync: this,
      duration: widget.countUpDuration,
    );

    if (widget.isReady) {
      _wasReady = true;
      _hasCompletedCountUp = true;
      _displayText = _formatCurrency(widget.targetAmount);
    } else {
      _displayText = _formatCurrency(_randomAmount());
      _startScramble();
    }
  }

  @override
  void didUpdateWidget(ScrambleCurrencyText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_wasReady && widget.isReady) {
      _wasReady = true;
      _stopScramble();
      _startCountUp();
    } else if (_hasCompletedCountUp && widget.targetAmount != oldWidget.targetAmount) {
      setState(() {
        _displayText = _formatCurrency(widget.targetAmount);
      });
    }
  }

  void _startScramble() {
    _scrambleTimer = Timer.periodic(widget.scrambleDuration, (_) {
      if (mounted) {
        setState(() {
          _displayText = _formatCurrency(_randomAmount());
        });
      }
    });
  }

  void _stopScramble() {
    _scrambleTimer?.cancel();
    _scrambleTimer = null;
  }

  void _startCountUp() {
    final animation = Tween<double>(
      begin: 0,
      end: widget.targetAmount,
    ).animate(CurvedAnimation(parent: _countUpController, curve: widget.countUpCurve));

    void onTick() {
      setState(() {
        _displayText = _formatCurrency(animation.value);
      });
    }

    void onStatus(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _hasCompletedCountUp = true;
        setState(() {
          _displayText = _formatCurrency(widget.targetAmount);
        });
        _countUpController.removeListener(onTick);
        _countUpController.removeStatusListener(onStatus);
      }
    }

    _countUpController.addListener(onTick);
    _countUpController.addStatusListener(onStatus);
    _countUpController.forward();
  }

  double _randomAmount() {
    return _random.nextDouble() * 9899 + 100;
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: widget.currencySymbol).format(amount);
  }

  @override
  void dispose() {
    _stopScramble();
    _countUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayText, style: widget.style);
  }
}
