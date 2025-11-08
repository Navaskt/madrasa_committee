import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../core/models/member_model/members.dart';

class MembersListScreen extends ConsumerWidget {
  const MembersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: StreamBuilder<List<Member>>(
        stream: ref.read(memberRepoProvider).streamAllMembers(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('No members'));
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (_, i) {
              final m = list[i];
              return ListTile(
                title: Text(m.name),
                subtitle: Text('${m.email} • AED ${m.monthlyFee}/month'),
                trailing: m.isAdmin ? const Chip(label: Text('Admin')) : null,
              );
            },
          );
        },
      ),
    );
  }
}
