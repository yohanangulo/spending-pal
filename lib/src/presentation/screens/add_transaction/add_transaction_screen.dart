import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/screen_wrapper/screen_wrapper.dart';
import 'package:spending_pal/src/presentation/common/widgets/speech_to_text_bloc_widget.dart';
import 'package:spending_pal/src/presentation/core/speech_to_text/speech_to_text_bloc.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/bloc/add_transaction_bloc.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/add_transaction_amount_field.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/add_transaction_description_field.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/add_transaction_tab_bar.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/category_selector.dart';

class AddTransactionScreen extends StatefulWidget implements WrappedScreen {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();

  @override
  Widget buildWrapper(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AddTransactionBloc>()),
        BlocProvider(create: (context) => getIt<SpeechToTextBloc>()),
      ],
      child: this,
    );
  }
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    AppNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    void updateDescription(String description) {
      _descriptionController.text = description;
    }

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar Transacción'),
          actions: [
            TextButton(
              onPressed: _onSavePressed,
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Guardar'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.p4),
            child: Column(
              children: [
                const AddTransactionTabBar(),
                const SizedBox(height: Dimens.p9),
                Text(
                  'Monto',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                AddTransactionAmountField(controller: _amountController),
                const SizedBox(height: Dimens.p5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Descripción',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.p1),
                AddTransactionDescriptionField(controller: _descriptionController),
                const SizedBox(height: Dimens.p5),
                const CategorySelector(),
                const SizedBox(height: Dimens.p4),
                SpeechToTextBlocWidget(
                  hintText: 'Toca para hablar y agregar una transacción',
                  onFinalResult: updateDescription,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
