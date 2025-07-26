import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/core/app_localizations_cubit/app_localizations_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.language),
      ),
      body: const Padding(
        padding: EdgeInsets.all(Dimens.p4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona tu idioma preferido:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: Dimens.p6),
            _LanguageTile(
              locale: Locale('en'),
              title: 'English',
              icon: Icons.language,
            ),
            _LanguageTile(
              locale: Locale('es'),
              title: 'Español',
              icon: Icons.language,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.locale,
    required this.title,
    required this.icon,
  });

  final Locale locale;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLocalizationsCubit, Locale>(
      builder: (context, currentLocale) {
        final isSelected = currentLocale.languageCode == locale.languageCode;
        final cubit = context.read<AppLocalizationsCubit>();
        return Card(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : null,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ListTile(
              leading: Icon(icon, color: isSelected ? AppColors.primary : null),
              title: Text(title),
              onTap: () => cubit.changeLocale(locale),
            ),
          ),
        );
      },
    );
  }
}
