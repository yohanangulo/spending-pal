import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/categories/bloc/categories_bloc.dart';

class CategoryFilterBottomSheet extends StatelessWidget {
  const CategoryFilterBottomSheet({super.key, this.selectedCategoryId});

  final String? selectedCategoryId;

  static Future<Category?> show(BuildContext context, {String? selectedCategoryId}) {
    return showModalBottomSheet<Category>(
      context: context,
      showDragHandle: true,
      builder: (_) => CategoryFilterBottomSheet(selectedCategoryId: selectedCategoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoriesBloc>()..add(CategoriesSubscriptionRequested()),
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.p4),
                child: Text(
                  'Select Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category.id == selectedCategoryId;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category.color.toColor().withValues(alpha: 0.2),
                      child: Icon(
                        category.icon.toIconData(),
                        color: category.color.toColor(),
                        size: 20,
                      ),
                    ),
                    title: Text(category.name),
                    selected: isSelected,
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.of(context).pop(category),
                  );
                },
              ),
              const SizedBox(height: Dimens.p4),
            ],
          );
        },
      ),
    );
  }
}
