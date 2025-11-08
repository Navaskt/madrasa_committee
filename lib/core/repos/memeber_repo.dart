import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member_model/members.dart';

class MemberRepo {
  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _members => _db.collection('members');

  Future<void> upsertMember(Member m) async {
    await _members.doc(m.uid).set(m.toJson(), SetOptions(merge: true));
  }

  Future<Member?> getMember(String uid) async {
    final doc = await _members.doc(uid).get();
    if (!doc.exists) return null;
    return Member.fromJson(doc.data()!);
  }

  Future<bool> isAdmin(String uid) async {
    final m = await getMember(uid);
    return m?.isAdmin ?? false;
  }

  Stream<List<Member>> streamAllMembers() {
    return _members.orderBy('name').snapshots().map((s) =>
      s.docs.map((d) => Member.fromJson(d.data())).toList());
  }
}
