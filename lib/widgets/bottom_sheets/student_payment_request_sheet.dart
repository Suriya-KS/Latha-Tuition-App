import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/date_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class StudentPaymentRequestSheet extends ConsumerStatefulWidget {
  const StudentPaymentRequestSheet({
    this.feesAmount,
    super.key,
  });

  final num? feesAmount;

  @override
  ConsumerState<StudentPaymentRequestSheet> createState() =>
      _StudentPaymentRequestSheetState();
}

class _StudentPaymentRequestSheetState
    extends ConsumerState<StudentPaymentRequestSheet> {
  final paymentsCollectionReference =
      FirebaseFirestore.instance.collection('payments');
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  ScaffoldMessengerState? scaffoldMessengerState;

  late TextEditingController feesAmountController;
  late TextEditingController paymentDateController;

  void raisePaymentRequest(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    setState(() {
      isLoading = true;
    });

    try {
      final parsedDate = DateFormat('MMMM d, yyyy').parse(
        paymentDateController.text,
      );
      final currentDateWithTime = DateTime.now();
      final combinedDateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        currentDateWithTime.hour,
        currentDateWithTime.minute,
        currentDateWithTime.second,
        currentDateWithTime.millisecond,
        currentDateWithTime.microsecond,
      );

      await paymentsCollectionReference.add({
        'studentID': studentID,
        'date': combinedDateTime,
        'amount': num.parse(feesAmountController.text),
        'status': 'pending approval',
      });

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    feesAmountController = TextEditingController();
    paymentDateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    feesAmountController.dispose();
    paymentDateController.dispose();
    scaffoldMessengerState?.hideCurrentSnackBar();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    const duration = Duration(days: 365 * 2);

    return Column(
      children: [
        const TitleText(title: 'Raise Payment Request'),
        const SizedBox(height: 30),
        Form(
          key: formKey,
          child: Column(
            children: [
              TextInput(
                labelText: 'Fees Amount',
                prefixIcon: Icons.currency_rupee_outlined,
                inputType: TextInputType.number,
                initialValue: widget.feesAmount.toString(),
                validator: validateFeesAmount,
                controller: feesAmountController,
              ),
              const SizedBox(height: 10),
              DateInput(
                labelText: 'Payment Date',
                prefixIcon: Icons.calendar_month,
                initialDate: DateTime.now(),
                firstDate: currentDate.subtract(duration),
                lastDate: currentDate.add(duration),
                validator: (value) => validateRequiredInput(
                  value,
                  'a',
                  'date',
                ),
                controller: paymentDateController,
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                title: 'Request',
                isLoading: isLoading,
                onPressed: () => raisePaymentRequest(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
