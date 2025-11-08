import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model/payment.dart';

class PaymentRepo {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _paymentsCol(String memberId) =>
      _db.collection('members').doc(memberId).collection('payments');

  Future<void> addPayment(Payment p) async {
    await _paymentsCol(p.memberId).doc(p.id).set(p.toJson());
  }

  Stream<List<Payment>> streamMemberPayments(String memberId) {
    return _paymentsCol(memberId)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Payment.fromJson(d.data())).toList());
  }

  Future<int> getPaidForMonth(String memberId, int month, int year) async {
    final snap = await _paymentsCol(memberId)
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .get();
    if (snap.docs.isEmpty) return 0;
    int total = 0;
    for (var doc in snap.docs) {
      total += (doc.data()['amount'] as num).toInt();
    }
    return total;
  }
}
