import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/short_url_model.dart';

class FirebaseUrlDataSource {
  static const String _collectionName = 'short_urls';

  final FirebaseFirestore _firestore;

  const FirebaseUrlDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionName);

  Future<void> addUrl(ShortUrlModel model) async {
    await _collection.add(<String, dynamic>{
      'originalUrl': model.originalUrl,
      'shortUrl': model.shortUrl,
      'createdAt': Timestamp.fromDate(model.createdAt),
    });
  }

  Future<List<ShortUrlModel>> getHistory() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _collection.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map(_fromDoc).toList();
  }

  Future<void> deleteUrl(String shortUrl) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _collection.where('shortUrl', isEqualTo: shortUrl).get();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  ShortUrlModel _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    final dynamic rawCreatedAt = data['createdAt'];
    final DateTime createdAt =
        rawCreatedAt is Timestamp ? rawCreatedAt.toDate() : DateTime.now();
    return ShortUrlModel(
      originalUrl: data['originalUrl'] as String? ?? '',
      shortUrl: data['shortUrl'] as String? ?? '',
      createdAt: createdAt,
    );
  }
}
