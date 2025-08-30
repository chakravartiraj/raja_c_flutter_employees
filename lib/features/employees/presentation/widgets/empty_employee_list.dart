import 'package:flutter/material.dart';

class EmptyEmployeeList extends StatelessWidget {
  const EmptyEmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.transparent,
                BlendMode.srcATop,
              ),
              child: Image.asset(
                'assets/images/empty_team.png', // Added this PNG to assets
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            /*const SizedBox(height: 24),
            Text(
              'No employee records found',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button below to add your first employee.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/add-employee'),
              icon: const Icon(Icons.person_add),
              label: const Text('Add Employee'),
            ),*/
          ],
        ),
      ),
    );
  }
}
