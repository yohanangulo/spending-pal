import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/presentation/screens/account/widgets/account_option.dart';
import 'package:spending_pal/src/presentation/screens/account/widgets/account_section.dart';

class GeneralSection extends StatelessWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountSection(
      children: [
        AccountOption(
          icon: Icons.category,
          title: 'Categories',
          onTap: AppNavigator.navigateToCategories,
        ),
      ],
    );
  }
}
