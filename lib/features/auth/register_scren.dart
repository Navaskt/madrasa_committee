import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/providers.dart';
import '../../core/models/member_model/members.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _monthly = TextEditingController(text: '50'); // default AED 50
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Enter name',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (v) => (v != null && v.length >= 6) ? null : 'Min 6 characters',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _address,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _monthly,
                    decoration: const InputDecoration(labelText: 'Monthly fee (AED)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      return (n != null && n >= 0) ? null : 'Enter a number';
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loading ? null : () async {
                      if (!_form.currentState!.validate()) return;
                      setState(() => _loading = true);
                      try {
                        final cred = await ref.read(authServiceProvider).register(
                              _email.text.trim(),
                              _password.text,
                            );
                        final member = Member(
                          uid: cred.user!.uid,
                          name: _name.text.trim(),
                          email: _email.text.trim(),
                          phone: _phone.text.trim(),
                          address: _address.text.trim(),
                          monthlyFee: int.parse(_monthly.text.trim()),
                          isAdmin: false,
                        );
                        await ref.read(memberRepoProvider).upsertMember(member);
                        context.go('/');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register failed: $e')));
                      } finally {
                        if (mounted) setState(() => _loading = false);
                      }
                    },
                    child: Text(_loading ? 'Please wait...' : 'Create account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
