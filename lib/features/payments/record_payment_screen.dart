import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controllers/providers.dart';
import '../../core/models/member_model/members.dart';
import '../../core/models/payment_model/payment.dart';

class RecordPaymentScreen extends ConsumerStatefulWidget {
  const RecordPaymentScreen({super.key});

  @override
  ConsumerState<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends ConsumerState<RecordPaymentScreen> {
  Member? _selected;
  final _amount = TextEditingController();
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;
  final _note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _MemberDropDown(
              onSelected: (m) {
                setState(() => _selected = m);
                _amount.text = m.monthlyFee.toString();
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _month,
                    items: List.generate(12, (i) => i + 1)
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(DateFormat.MMMM().format(DateTime(2000, m))),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _month = v ?? _month),
                    decoration: const InputDecoration(labelText: 'Month'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _year,
                    items: List.generate(5, (i) => DateTime.now().year - 2 + i)
                        .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                        .toList(),
                    onChanged: (v) => setState(() => _year = v ?? _year),
                    decoration: const InputDecoration(labelText: 'Year'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amount,
              decoration: const InputDecoration(labelText: 'Amount (AED)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _selected == null
                  ? null
                  : () async {
                      final id = 'p_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}';
                      final parsed = int.tryParse(_amount.text.trim());
                      final p = Payment(
                        id: id,
                        memberId: _selected!.uid,
                        amount: parsed ?? _selected!.monthlyFee,
                        month: _month,
                        year: _year,
                        createdAt: DateTime.now(),
                        note: _note.text.trim(),
                      );
                      await ref.read(paymentRepoProvider).addPayment(p);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment saved')));
                      }
                    },
              child: const Text('Save payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberDropDown extends ConsumerStatefulWidget {
  const _MemberDropDown({required this.onSelected});
  final void Function(Member m) onSelected;

  @override
  ConsumerState<_MemberDropDown> createState() => _MemberDropDownState();
}

class _MemberDropDownState extends ConsumerState<_MemberDropDown> {
  Member? _selected;

  @override
  Widget build(BuildContext context) {
    final stream = ref.read(memberRepoProvider).streamAllMembers();

    return StreamBuilder<List<Member>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snap.hasError) {
          return Text('Failed to load members: ${snap.error}');
        }

        final list = snap.data ?? const [];
        if (list.isEmpty) return const Text('No members found');

        // Keep selection valid if list updates
        if (_selected != null) {
          final stillExists = list.any((m) => m.uid == _selected!.uid);
          if (!stillExists) _selected = null;
        }

        return DropdownButtonFormField<Member>(
          value: _selected,
          isExpanded: true,
          items: list
              .map(
                (m) => DropdownMenuItem<Member>(
                  value: m,
                  child: Text(m.name.isNotEmpty ? m.name : m.email),
                ),
              )
              .toList(),
          onChanged: (m) {
            if (m == null) return;
            setState(() => _selected = m);
            widget.onSelected(m);
          },
          decoration: const InputDecoration(labelText: 'Member'),
        );
      },
    );
  }
}
