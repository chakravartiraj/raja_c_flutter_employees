import 'package:flutter/material.dart';
import 'package:raja_c_flutter_employees/core/utils/date_formatter.dart';

class CustomDateField extends FormField<DateTime> {
  final String hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final bool? hasExternalError;

  CustomDateField({
    super.key,
    required this.hintText,
    required this.selectedDate,
    required this.onDateChanged,
    this.hasExternalError,
    super.validator,
    super.initialValue,
  }) : super(
         builder: (FormFieldState<DateTime> field) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               GestureDetector(
                 onTap: () async {
                   final picked = await showDatePicker(
                     context: field.context,
                     initialDate: selectedDate ?? DateTime.now(),
                     firstDate: DateTime(2000),
                     lastDate: DateTime(2100),
                   );
                   if (picked != null && picked != selectedDate) {
                     onDateChanged(picked);
                     field.didChange(picked);
                   }
                 },
                 child: Container(
                   padding: const EdgeInsets.all(16.0),
                   decoration: BoxDecoration(
                     border: Border.all(
                       color: (field.hasError || hasExternalError == true)
                           ? Theme.of(field.context).colorScheme.error
                           : Theme.of(field.context).dividerColor,
                     ),
                     borderRadius: BorderRadius.circular(8),
                   ),
                   child: Row(
                     children: [
                       Icon(
                         Icons.calendar_today,
                         color: Theme.of(field.context).iconTheme.color,
                       ),
                       const SizedBox(width: 12),
                       Expanded(
                         child: Text(
                           selectedDate != null
                               ? DateFormatter.formatDate(selectedDate)
                               : hintText,
                           style: TextStyle(
                             fontSize: 14,
                             fontWeight: FontWeight.w400,
                             color: selectedDate != null
                                 ? Theme.of(
                                     field.context,
                                   ).textTheme.bodyLarge?.color
                                 : Colors.grey,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               if (field.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 8, left: 12),
                   child: Text(
                     field.errorText!,
                     style: TextStyle(
                       color: Theme.of(field.context).colorScheme.error,
                       fontSize: 12,
                     ),
                   ),
                 ),
             ],
           );
         },
       );
}
