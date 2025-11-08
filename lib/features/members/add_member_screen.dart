import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/providers.dart';
import '../../core/models/member_model/members.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({super.key});

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final _form = GlobalKey<FormState>();
  final _uid = TextEditingController(); // Existing auth UID if you pre-created user
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _monthly = TextEditingController(text: '50');
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Member (Admin)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(controller: _uid, decoration: const InputDecoration(labelText: 'Auth UID (optional)')),
              const SizedBox(height: 8),
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: _req),
              const SizedBox(height: 8),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
              const SizedBox(height: 8),
              TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address')),
              const SizedBox(height: 8),
              TextFormField(
                controller: _monthly,
                decoration: const InputDecoration(labelText: 'Monthly fee (AED)'),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v ?? '') != null ? null : 'Enter a number',
              ),
              SwitchListTile(
                value: _isAdmin,
                onChanged: (v) => setState(() => _isAdmin = v),
                title: const Text('Admin'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (!_form.currentState!.validate()) return;
                  final uid = _uid.text.trim().isEmpty
                      ? (ref.read(authServiceProvider).currentUser?.uid ?? '')
                      : _uid.text.trim();
                  if (uid.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UID required or sign in as the member to link')));
                    return;
                  }
                  final m = Member(
                    uid: uid,
                    name: _name.text.trim(),
                    email: _email.text.trim(),
                    phone: _phone.text.trim(),
                    address: _address.text.trim(),
                    monthlyFee: int.parse(_monthly.text.trim()),
                    isAdmin: _isAdmin,
                  );
                  await ref.read(memberRepoProvider).upsertMember(m);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Member saved')));
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _req(String? v) => (v != null && v.trim().isNotEmpty) ? null : 'Required';
}
