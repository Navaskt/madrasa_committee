import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../core/models/payment_model/payment.dart';

class MemberPaymentsScreen extends ConsumerWidget {
  const MemberPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(authServiceProvider).currentUser!.uid;
    final stream = ref.read(paymentRepoProvider).streamMemberPayments(uid);

    return Scaffold(
      appBar: AppBar(title: const Text('My Payments')),
      body: StreamBuilder<List<Payment>>(
        stream: stream,
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final items = snap.data!;
          if (items.isEmpty) return const Center(child: Text('No payments yet'));
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (_, i) {
              final p = items[i];
              return ListTile(
                title: Text('AED ${p.amount} - ${p.month}/${p.year}'),
                subtitle: Text(p.note.isEmpty ? 'Recorded' : p.note),
                trailing: Text(p.createdAt.toLocal().toString().split('.').first),
              );
            },
          );
        },
      ),
    );
  }
}
