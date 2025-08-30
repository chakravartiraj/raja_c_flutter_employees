import 'package:flutter/material.dart';

class CustomInputField extends FormField<String> {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;

  CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    super.validator,
    super.initialValue,
  }) : super(
         builder: (FormFieldState<String> field) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               TextFormField(
                 controller: controller,
                 onChanged: (value) => field.didChange(value),
                 decoration: InputDecoration(
                   hintText: hintText,
                   hintStyle: const TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.w400,
                     color: Colors.grey,
                   ),
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                   ),
                   enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                     borderSide: BorderSide(
                       color: field.hasError
                           ? Theme.of(field.context).colorScheme.error
                           : Theme.of(field.context).dividerColor,
                     ),
                   ),
                   focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                     borderSide: BorderSide(
                       color: field.hasError
                           ? Theme.of(field.context).colorScheme.error
                           : Theme.of(field.context).colorScheme.primary,
                     ),
                   ),
                   errorBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                     borderSide: BorderSide(
                       color: Theme.of(field.context).colorScheme.error,
                     ),
                   ),
                   focusedErrorBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                     borderSide: BorderSide(
                       color: Theme.of(field.context).colorScheme.error,
                     ),
                   ),
                   prefixIcon: Icon(
                     icon,
                     color: Theme.of(field.context).iconTheme.color,
                   ),
                   errorText: null, // We'll handle error display manually
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
