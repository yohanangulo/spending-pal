import 'package:flutter/material.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';

class DeleteCategoryDialog extends StatelessWidget {
  const DeleteCategoryDialog({
    required this.category,
    required this.onDelete,
    required this.onCancel,
    super.key,
  });

  final Category category;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Category'),
      content: Text('Are you sure you want to delete "${category.name}"?'),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onDelete,
          child: const Text(
            'Delete',
            style: TextStyle(
              color: AppColors.destructive,
            ),
          ),
        ),
      ],
    );
  }
}
