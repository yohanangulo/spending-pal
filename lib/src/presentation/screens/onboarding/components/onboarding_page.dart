import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/onboarding/onboarding_page_data.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.data,
    super.key,
  });

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (data.background != null)
          Positioned(
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.04,
              child: data.background,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.p10, horizontal: Dimens.p7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Flexible(
                flex: 20,
                child: data.image,
              ),
              const Spacer(),
              Text(
                data.title,
                style: TextStyle(
                  color: data.titleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                maxLines: 1,
              ),
              const Spacer(),
              Text(
                data.subtitle,
                style: TextStyle(
                  color: data.subtitleColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                // maxLines: 2,
              ),
              const Spacer(flex: 10),
            ],
          ),
        ),
      ],
    );
  }
}
