import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/common/blocs/theme_mode_cubit.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Mode'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(Dimens.p4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your preferred theme:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: Dimens.p6),
            _ThemeModeTile(
              value: ThemeMode.light,
              title: 'Light',
              icon: Icons.light_mode_outlined,
            ),
            _ThemeModeTile(
              value: ThemeMode.dark,
              title: 'Dark',
              icon: Icons.dark_mode_outlined,
            ),
            _ThemeModeTile(
              value: ThemeMode.system,
              title: 'System',
              icon: Icons.phone_android_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.value,
    required this.title,
    required this.icon,
  });

  final ThemeMode value;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == context.select((ThemeModeCubit c) => c.state);
    final cubit = context.read<ThemeModeCubit>();
    return Card(
      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
      child: Theme(
        data: context.theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ListTile(
          leading: Icon(icon, color: isSelected ? AppColors.primary : null),
          title: Text(title),
          onTap: () => cubit.changeThemeMode(value),
        ),
      ),
    );
  }
}
