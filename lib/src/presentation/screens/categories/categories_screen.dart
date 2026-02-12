import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/screen_wrapper/screen_wrapper.dart';
import 'package:spending_pal/src/presentation/screens/categories/bloc/categories_bloc.dart';
import 'package:spending_pal/src/presentation/screens/categories/components/summary_card.dart';
import 'package:spending_pal/src/presentation/screens/categories/widgets/add_category_dialog.dart';
import 'package:spending_pal/src/presentation/screens/categories/widgets/category_card.dart';
import 'package:spending_pal/src/presentation/screens/categories/widgets/delete_category_dialog.dart';

class CategoriesScreen extends StatelessWidget implements WrappedScreen {
  const CategoriesScreen({
    super.key,
    this.isSelectingCategory = false,
  });

  final bool isSelectingCategory;

  @override
  Widget buildWrapper(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoriesBloc>()..add(CategoriesSubscriptionRequested()),
      child: this,
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final bloc = context.read<CategoriesBloc>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: AddCategoryDialog(
          onAdd: () {
            bloc.add(CategoriesCreateRequested());
            context.pop();
          },
          onCancel: context.pop,
        ),
      ),
    );
  }

  void _showEditCategoryDialog(Category category, BuildContext context) {
    final bloc = context.read<CategoriesBloc>();
    bloc.add(CategoriesSetEditingCategory(category: category));
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: AddCategoryDialog(
          isEditing: true,
          onAdd: () {
            bloc.add(CategoriesCreateRequested());
            context.pop();
          },
          onCancel: context.pop,
        ),
      ),
    );
  }

  void _showDeleteCategoryDialog(Category category, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteCategoryDialog(
        category: category,
        onDelete: () {
          Navigator.of(context).pop();
          context.read<CategoriesBloc>().add(CategoriesDeleteRequested(id: category.id));
          context.showSnackBar(
            SnackBar(
              content: Text('${category.name} deleted'),
            ),
          );
        },
        onCancel: context.pop,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safePaddingBottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () => _showAddCategoryDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SummaryCard(),
          BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) => SliverList.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.p4, vertical: Dimens.p2),
                child: CategoryCard(
                  category: state.categories[index],
                  onEdit: () => _showEditCategoryDialog(state.categories[index], context),
                  onDelete: () => _showDeleteCategoryDialog(state.categories[index], context),
                  onTap: () {
                    if (isSelectingCategory) return context.pop(state.categories[index]);

                    // TODO: implement some sort of navigation
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: Dimens.p4 + safePaddingBottom),
          ),
        ],
      ),
    );
  }
}
