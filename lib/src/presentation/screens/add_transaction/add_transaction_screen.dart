import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/extensions/string_extensions.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/screen_wrapper/screen_wrapper.dart';
import 'package:spending_pal/src/presentation/common/widgets/speech_to_text_bloc_widget.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';
import 'package:spending_pal/src/presentation/core/speech_to_text/speech_to_text_bloc.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/bloc/add_transaction_bloc.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/add_transaction_amount_field.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/add_transaction_description_field.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/add_transaction_tab_bar.dart';
import 'package:spending_pal/src/presentation/screens/add_transaction/components/category_selector_form_field.dart';

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
  final _formKey = GlobalKey<FormState>();

  late final CurrencyTextInputFormatter formatter;

  @override
  void initState() {
    super.initState();
    formatter = CurrencyTextInputFormatter.currency(
      symbol: r'$',
      decimalDigits: 2,
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final bloc = context.read<AddTransactionBloc>();
    final authBloc = context.read<AuthBloc>();

    final description = _descriptionController.text.trim();
    final amount = formatter.getUnformattedValue();

    if (!_formKey.currentState!.validate()) return;

    final event = AddTransactionSaveRequested(
      userId: authBloc.state.user!.uid,
      amount: amount.toDouble(),
      description: description,
    );
    bloc.add(event);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    void updateDescription(String description) {
      _descriptionController.text = description;
    }

    return BlocListener<AddTransactionBloc, AddTransactionState>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.showSnackBar(const SnackBar(content: Text('Transaction saved!')));
          AppNavigator.pop();
        } else if (state.hasError) {
          context.showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error saving transaction'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Agregar Transacción'),
            actions: [
              BlocBuilder<AddTransactionBloc, AddTransactionState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: state.isLoading ? null : _onSavePressed,
                    style: TextButton.styleFrom(
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar'),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.p4),
              child: Form(
                key: _formKey,
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
                    AddTransactionAmountField(
                      controller: _amountController,
                      formatter: formatter,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }

                        if (formatter.getUnformattedValue().toDouble() <= 0) {
                          return 'Amount must be greater than 0';
                        }

                        return null;
                      },
                    ),
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
                    AddTransactionDescriptionField(
                      controller: _descriptionController,
                      validator: (value) {
                        final sanitized = value?.sanitized;
                        if (sanitized == null || sanitized.isEmpty) {
                          return 'Please enter a description';
                        }

                        if (sanitized.length < 3) {
                          return 'Description must be at least 3 characters';
                        }

                        if (sanitized.length > 200) {
                          return 'Description must be less than 200 characters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: Dimens.p5),
                    CategorySelectorFormField(
                      validator: (Category? category) {
                        if (category == null) {
                          return 'Please select a category';
                        }

                        return null;
                      },
                    ),
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
        ),
      ),
    );
  }
}
