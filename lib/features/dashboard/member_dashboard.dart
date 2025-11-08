import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/providers.dart';
import '../../core/models/member_model/members.dart';

class MemberDashboard extends ConsumerWidget {
  const MemberDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authServiceProvider).currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.go('/payments/me'),
            icon: const Icon(Icons.history),
            tooltip: 'My payments',
          ),
          IconButton(
            onPressed: () => ref.read(authServiceProvider).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<Member?>(
        future: ref.read(memberRepoProvider).getMember(user!.uid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData || snap.data == null) {
            return const Center(child: Text('No member data found.'));
          }
          final m = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: ListTile(
                title: Text(m.name),
                subtitle: Text('Monthly fee: AED ${m.monthlyFee}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
