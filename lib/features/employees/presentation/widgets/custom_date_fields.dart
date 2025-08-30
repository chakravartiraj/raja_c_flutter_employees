import 'package:flutter/material.dart';
import 'package:raja_c_flutter_employees/features/employees/presentation/widgets/custom_date_field.dart';

class CustomDateFields extends FormField<Map<String, DateTime?>> {
  final DateTime? joinDate;
  final DateTime? exitDate;
  final ValueChanged<DateTime> onJoinDateChanged;
  final ValueChanged<DateTime> onExitDateChanged;

  CustomDateFields({
    super.key,
    required this.joinDate,
    required this.exitDate,
    required this.onJoinDateChanged,
    required this.onExitDateChanged,
    super.validator,
  }) : super(
         initialValue: {'joinDate': joinDate, 'exitDate': exitDate},
         builder: (FormFieldState<Map<String, DateTime?>> field) {
           return _CustomDateFieldsWidget(
             field: field,
             joinDate: joinDate,
             exitDate: exitDate,
             onJoinDateChanged: onJoinDateChanged,
             onExitDateChanged: onExitDateChanged,
           );
         },
       );
}

class _CustomDateFieldsWidget extends StatefulWidget {
  final FormFieldState<Map<String, DateTime?>> field;
  final DateTime? joinDate;
  final DateTime? exitDate;
  final ValueChanged<DateTime> onJoinDateChanged;
  final ValueChanged<DateTime> onExitDateChanged;

  const _CustomDateFieldsWidget({
    required this.field,
    required this.joinDate,
    required this.exitDate,
    required this.onJoinDateChanged,
    required this.onExitDateChanged,
  });

  @override
  State<_CustomDateFieldsWidget> createState() =>
      _CustomDateFieldsWidgetState();
}

class _CustomDateFieldsWidgetState extends State<_CustomDateFieldsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDateField(
                hintText: 'Joining Date',
                selectedDate: widget.joinDate,
                hasExternalError: widget.field.hasError,
                onDateChanged: (date) {
                  widget.onJoinDateChanged(date);
                  widget.field.didChange({
                    'joinDate': date,
                    'exitDate': widget.field.value?['exitDate'],
                  });
                  // Trigger rebuild to update error states
                  setState(() {});
                },
                validator: (date) => null, // Individual validation disabled
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.arrow_forward,
                color: widget.field.hasError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).iconTheme.color,
              ),
            ),
            Expanded(
              child: CustomDateField(
                hintText: 'Exit Date',
                selectedDate: widget.exitDate,
                hasExternalError: widget.field.hasError,
                onDateChanged: (date) {
                  widget.onExitDateChanged(date);
                  widget.field.didChange({
                    'joinDate': widget.field.value?['joinDate'],
                    'exitDate': date,
                  });
                  // Trigger rebuild to update error states
                  setState(() {});
                },
                validator: (date) => null, // Individual validation disabled
              ),
            ),
          ],
        ),
        if (widget.field.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              widget.field.errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
