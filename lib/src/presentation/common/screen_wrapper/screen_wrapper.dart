import 'package:flutter/widgets.dart';

abstract class WrappedScreen {
  Widget buildWrapper(BuildContext context);
}

class BuildWrappedScreen extends StatelessWidget {
  const BuildWrappedScreen({
    required this.view,
    super.key,
  });

  final WrappedScreen view;

  @override
  Widget build(BuildContext context) {
    return view.buildWrapper(context);
  }
}

extension WrappedScreenExtension on WrappedScreen {
  Widget wrap() {
    return BuildWrappedScreen(
      view: this,
    );
  }
}
