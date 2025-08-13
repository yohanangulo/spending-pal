import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/widgets/app_button.dart';
import 'package:spending_pal/src/presentation/screens/categories/bloc/categories_bloc.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({
    required this.onAdd,
    required this.onCancel,
    this.isEditing = false,
    super.key,
  });

  final VoidCallback onAdd;
  final VoidCallback onCancel;
  final bool isEditing;

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();

  final List<IconData> _availableIcons = [
    Icons.restaurant,
    Icons.directions_car,
    Icons.shopping_bag,
    Icons.movie,
    Icons.medical_services,
    Icons.electric_bolt,
    Icons.home,
    Icons.school,
    Icons.sports_esports,
    Icons.flight,
  ];

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  void deactivate() {
    context.read<CategoriesBloc>().add(CategoriesResetForm());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CategoriesBloc>();
    return AlertDialog(
      title: const Text('Add Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _NameField(),
            const SizedBox(height: Dimens.p4),
            const Text('Select Icon:'),
            const SizedBox(height: Dimens.p2),
            Wrap(
              runSpacing: Dimens.p2,
              spacing: Dimens.p2,
              children: _availableIcons.map((icon) {
                return _IconItem(
                  icon: icon,
                  onTap: () => bloc.add(CategoriesIconChanged(icon: icon)),
                );
              }).toList(),
            ),
            const SizedBox(height: Dimens.p4),
            const Text('Select Color:'),
            const SizedBox(height: Dimens.p2),
            Wrap(
              runSpacing: Dimens.p2,
              spacing: Dimens.p2,
              children: _availableColors.map((color) {
                return _ColorItem(
                  color: color,
                  onTap: () => bloc.add(CategoriesColorChanged(color: color)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Cancel'),
        ),
        BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state.editingCategory == null) {
              return AppButton(
                isEnabled: !state.nameAlreadyExists && state.isFormValid,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onAdd();
                  }
                },
                child: const Text('Add'),
              );
            }

            return AppButton(
              isEnabled: state.isFormValid && state.errorText == null,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onAdd();
                }
              },
              child: const Text('Save'),
            );
          },
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CategoriesBloc>();
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.editingCategory?.name,
          onChanged: (value) => bloc.add(CategoriesNameChanged(name: value)),
          decoration: InputDecoration(
            labelText: 'Category Name',
            border: const OutlineInputBorder(),
            errorText: state.errorText,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a category name';
            }

            if (value.length < 3) {
              return 'Category name must be at least 3 characters';
            }

            if (value.length > 20) {
              return 'Category name must be less than 20 characters';
            }

            return null;
          },
        );
      },
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({
    required this.color,
    required this.onTap,
  });

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CategoriesBloc>();
    final selectedColor = context.select((CategoriesBloc bloc) => bloc.state.color);
    return GestureDetector(
      onTap: () => bloc.add(CategoriesColorChanged(color: color)),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor?.toARGB32() == color.toARGB32()
                ? context.theme.brightness.isDark
                    ? Colors.white
                    : Colors.black
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _IconItem extends StatelessWidget {
  const _IconItem({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CategoriesBloc>();
    final selectedIcon = context.select((CategoriesBloc bloc) => bloc.state.selectedIcon);
    return GestureDetector(
      onTap: () => bloc.add(CategoriesIconChanged(icon: icon)),
      child: Container(
        padding: const EdgeInsets.all(Dimens.p2),
        decoration: BoxDecoration(
          color: selectedIcon == icon ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: selectedIcon == icon ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
