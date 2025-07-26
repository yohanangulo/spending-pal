import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class FAQItem {
  const FAQItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});
  List<FAQItem> get _faqItems {
    return const [
      FAQItem(
        question: 'How do I add a new expense?',
        answer:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
      FAQItem(
        question: 'How can I set a budget?',
        answer:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
      FAQItem(
        question: 'How do I change my password?',
        answer:
            'Go to Account Settings > Security > Change Password. You will need to enter your current password and create a new one.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.p4,
            vertical: Dimens.p2,
          ),
          child: Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: Dimens.p3),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _faqItems.length,
          itemBuilder: (_, index) => _FAQItem(item: _faqItems[index]),
        ),
      ],
    );
  }
}

class _FAQItem extends StatelessWidget {
  const _FAQItem({required this.item});
  final FAQItem item;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ExpansionTile(
      title: Text(
        item.question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Dimens.p4, 0, Dimens.p4, Dimens.p4),
          child: Text(
            item.answer,
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
