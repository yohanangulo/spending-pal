import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/help_and_support/components/contact_section.dart';
import 'package:spending_pal/src/presentation/screens/help_and_support/components/faq_section.dart';
import 'package:spending_pal/src/presentation/screens/help_and_support/components/header.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.p4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            const SizedBox(height: Dimens.p6),
            const FaqSection(),
            const SizedBox(height: Dimens.p6),
            const ContactSection(),
            SizedBox(height: MediaQuery.of(context).padding.bottom + Dimens.p6),
          ],
        ),
      ),
    );
  }
}
