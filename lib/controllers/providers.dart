import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/repos/memeber_repo.dart';
import '../core/repos/payment_repo.dart';
import '../core/service/auth_service.dart';
// Auth
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authStateProvider = StreamProvider((ref) => ref.watch(authServiceProvider).authStateChanges);

// Repos
final memberRepoProvider = Provider<MemberRepo>((ref) => MemberRepo());
final paymentRepoProvider = Provider<PaymentRepo>((ref) => PaymentRepo());
