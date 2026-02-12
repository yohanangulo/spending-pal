import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class LoadingBody extends StatelessWidget {
  const LoadingBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.p2),
          CircularProgressIndicator(color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}
