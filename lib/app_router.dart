import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/providers.dart';
import 'features/auth/register_scren.dart';
import 'features/dashboard/admin_dasgboard.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/member_dashboard.dart';
import 'features/members/add_member_screen.dart';
import 'features/members/members_list_screen.dart';
import 'features/payments/member_payments_screen.dart';
import 'features/payments/record_payment_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (c, s) => const AuthGate(),
        routes: [
          GoRoute(path: 'login', builder: (c, s) => const LoginScreen()),
          GoRoute(path: 'register', builder: (c, s) => const RegisterScreen()),
          GoRoute(path: 'admin', builder: (c, s) => const AdminDashboard()),
          GoRoute(path: 'member', builder: (c, s) => const MemberDashboard()),
          GoRoute(path: 'members/add', builder: (c, s) => const AddMemberScreen()),
          GoRoute(path: 'members', builder: (c, s) => const MembersListScreen()),
          GoRoute(path: 'payments/record', builder: (c, s) => const RecordPaymentScreen()),
          GoRoute(path: 'payments/me', builder: (c, s) => const MemberPaymentsScreen()),
        ],
      ),
    ],
  );
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (GoRouterState.of(context).uri.toString() != '/login') {
              GoRouter.of(context).go('/login');
            }
          });
        } else {
          // We can't await here, so we use .then() for the async operation
          ref.read(memberRepoProvider).isAdmin(user.uid).then((isAdmin) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                GoRouter.of(context).go(isAdmin ? '/admin' : '/member');
              }
            });
          });
        }
        // Show a loading indicator while the async check and navigation happens.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
