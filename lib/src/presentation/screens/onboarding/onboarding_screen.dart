import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/core/onboarding/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/generated/assets.gen.dart';
import 'package:spending_pal/src/presentation/screens/onboarding/components/onboarding_page.dart';
import 'package:spending_pal/src/presentation/screens/onboarding/onboarding_page_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  final data = [
    OnboardingPageData(
      title: 'Record your expenses with Siri',
      subtitle:
          'You can easily record your expenses using Siri voice commands, and the app will automatically categorize them for you.',
      image: Assets.images.talk.svg(width: 200),
      backgroundColor: AppColors.primary,
      titleColor: Colors.black,
      subtitleColor: Colors.black.withValues(alpha: 0.5),
      background: Assets.lottie.bg1.lottie(),
    ),
    OnboardingPageData(
      title: 'Track your expenses with ease',
      subtitle: 'Start tracking your expenses and see how much you spend on each category.',
      image: Assets.images.metrics.svg(width: 200),
      backgroundColor: Colors.white,
      titleColor: Colors.black,
      subtitleColor: const Color.fromRGBO(0, 10, 56, 1),
      background: Assets.lottie.bg1.lottie(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        pageController: pageController,
        itemCount: data.length,
        nextButtonBuilder: (context) {
          return TextButton(
            onPressed: () {
              if (pageController.page == data.length - 1) {
                getIt<OnboardingRepository>().setOnboardingCompleted();
                AppNavigator.navigateToLogin();
                return;
              }
              setState(() {
                currentPage = pageController.page!.toInt();
              });
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: data[currentPage].titleColor,
            ),
          );
        },
        colors: data.map((e) => e.backgroundColor).toList(),
        itemBuilder: (index) => OnboardingPage(data: data[index]),
      ),
    );
  }
}
