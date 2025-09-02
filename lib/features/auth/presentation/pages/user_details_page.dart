import 'package:flutter/material.dart';
import 'package:my_id/features/auth/domain/entities/user.dart';

class UserDetailsPage extends StatelessWidget {
  final User user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.firstName}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('First Name: ${user.firstName}'),
            Text('Last Name: ${user.lastName}'),
            Text('Middle Name: ${user.middleName ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
