import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
    this.showTrailing = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive ? AppColors.destructiveLight : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(Dimens.p2),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.destructive : AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDestructive ? AppColors.destructive : null,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: showTrailing ? (trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null)) : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.p4,
          vertical: Dimens.p1,
        ),
      ),
    );
  }
}
