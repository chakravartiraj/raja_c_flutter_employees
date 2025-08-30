import 'package:flutter/material.dart';
import 'package:raja_c_flutter_employees/features/employees/domain/entities/employee.dart';

class CustomRoleSelector extends FormField<EmployeeRole> {
  final EmployeeRole? selectedRole;
  final ValueChanged<EmployeeRole> onRoleSelected;

  CustomRoleSelector({
    super.key,
    this.selectedRole,
    required this.onRoleSelected,
    super.validator,
    super.initialValue,
  }) : super(
         builder: (FormFieldState<EmployeeRole> field) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               GestureDetector(
                 onTap: () {
                   showModalBottomSheet(
                     context: field.context,
                     isScrollControlled: true,
                     builder: (context) {
                       // Calculate adaptive height based on number of items
                       // Each ListTile is approximately 56dp + separator height
                       final itemCount = EmployeeRole.values.length;
                       final itemHeight = 56.0;
                       final separatorHeight = 0.5;
                       final totalHeight =
                           (itemCount * itemHeight) +
                           ((itemCount - 1) * separatorHeight) +
                           32.0; // Extra padding

                       return SizedBox(
                         height: totalHeight,
                         child: BottomSheet(
                           onClosing: () {},
                           builder: (context) => ListView.separated(
                             itemCount: EmployeeRole.values.length,
                             separatorBuilder: (context, index) => Divider(
                               height: 0.5,
                               thickness: 0.5,
                               indent: 16,
                               endIndent: 16,
                             ),
                             itemBuilder: (context, index) {
                               final role = EmployeeRole.values[index];
                               return ListTile(
                                 //  leading: const Icon(Icons.circle),
                                 title: Text(role.label),
                                 trailing: selectedRole == role
                                     ? const Icon(Icons.check)
                                     : null,
                                 onTap: () {
                                   Navigator.pop(context);
                                   onRoleSelected(role);
                                   field.didChange(role);
                                 },
                               );
                             },
                           ),
                         ),
                       );
                     },
                   );
                 },
                 child: Container(
                   padding: const EdgeInsets.all(16.0),
                   decoration: BoxDecoration(
                     border: Border.all(
                       color: field.hasError
                           ? Theme.of(field.context).colorScheme.error
                           : Theme.of(field.context).dividerColor,
                     ),
                     borderRadius: BorderRadius.circular(8),
                   ),
                   child: Row(
                     children: [
                       const Icon(Icons.work_outline),
                       const SizedBox(width: 12),
                       Expanded(
                         child: Text(
                           selectedRole?.label ?? 'Choose role',
                           style: TextStyle(
                             fontSize: 14,
                             fontWeight: FontWeight.w400,
                             color: selectedRole != null
                                 ? Theme.of(
                                     field.context,
                                   ).textTheme.bodyLarge?.color
                                 : Colors.grey,
                           ),
                         ),
                       ),
                       const Icon(Icons.arrow_drop_down),
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
