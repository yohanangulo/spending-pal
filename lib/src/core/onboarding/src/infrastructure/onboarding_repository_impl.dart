import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/local_storage/domain.dart';
import 'package:spending_pal/src/core/onboarding/domain.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(
    this._localStorage,
  );

  final LocalStorage _localStorage;
  final String _onboardingCompletedKey = 'is_onboading_completed';

  @override
  Future<bool> get isOnboardingCompleted async => await _localStorage.getBool(_onboardingCompletedKey) ?? false;

  @override
  void setOnboardingCompleted() => _localStorage.setBool(_onboardingCompletedKey, true);
}
