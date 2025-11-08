import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.go('/members'),
            icon: const Icon(Icons.group),
            tooltip: 'Members',
          ),
          IconButton(
            onPressed: () => context.go('/members/add'),
            icon: const Icon(Icons.person_add),
            tooltip: 'Add member',
          ),
          IconButton(
            onPressed: () => context.go('/payments/record'),
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Record payment',
          ),
          IconButton(
            onPressed: () => ref.read(authServiceProvider).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome, Admin')),
    );
  }
}
