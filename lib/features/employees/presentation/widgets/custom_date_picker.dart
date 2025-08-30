import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final String? buttonLabel;
  final String? noDateLabel;
  final String? cancelLabel;
  final String? saveLabel;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.buttonLabel,
    this.noDateLabel = 'No date',
    this.cancelLabel = 'Cancel',
    this.saveLabel = 'Save',
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _selectDate(DateTime? selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
    if (widget.onDateSelected != null && selectedDate != null) {
      widget.onDateSelected!(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          _selectDate(DateTime.now());
                        },
                        child: Text('Today'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          _selectDate(null);
                        },
                        child: Text(widget.noDateLabel ?? 'No date'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            _selectDate(pickedDate);
                            if (mounted) navigator.pop();
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300] ?? Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                  : widget.buttonLabel ?? 'Select Date',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
