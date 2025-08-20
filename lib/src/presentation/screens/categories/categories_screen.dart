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

class CategoriesScreen extends StatefulWidget implements WrappedScreen {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();

  @override
  Widget buildWrapper(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoriesBloc>()..add(CategoriesSubscriptionRequested()),
      child: this,
    );
  }
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void _showAddCategoryDialog() {
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

  void _showEditCategoryDialog(Category category) {
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

  void _showDeleteCategoryDialog(Category category) {
    showDialog(
      context: context,
      builder: (_) => DeleteCategoryDialog(
        category: category,
        onDelete: () {
          Navigator.of(context).pop();
          context.read<CategoriesBloc>().add(CategoriesDeleteRequested(id: category.id));
          context.showSnackbar(SnackBar(
            content: Text('${category.name} deleted'),
          ));
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
            onPressed: _showAddCategoryDialog,
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
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.p4, vertical: Dimens.p2),
                  child: CategoryCard(
                    category: state.categories[index],
                    onEdit: () => _showEditCategoryDialog(state.categories[index]),
                    onDelete: () => _showDeleteCategoryDialog(state.categories[index]),
                  ),
                );
              },
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
