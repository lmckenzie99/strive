import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NpsMetricsRecord extends FirestoreRecord {
  NpsMetricsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "npsScore" field.
  int? _npsScore;
  int get npsScore => _npsScore ?? 0;
  bool hasNpsScore() => _npsScore != null;

  // "npsComment" field.
  String? _npsComment;
  String get npsComment => _npsComment ?? '';
  bool hasNpsComment() => _npsComment != null;

  void _initializeFields() {
    _npsScore = castToType<int>(snapshotData['npsScore']);
    _npsComment = snapshotData['npsComment'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('npsMetrics');

  static Stream<NpsMetricsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NpsMetricsRecord.fromSnapshot(s));

  static Future<NpsMetricsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NpsMetricsRecord.fromSnapshot(s));

  static NpsMetricsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NpsMetricsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NpsMetricsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NpsMetricsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NpsMetricsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NpsMetricsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNpsMetricsRecordData({
  int? npsScore,
  String? npsComment,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'npsScore': npsScore,
      'npsComment': npsComment,
    }.withoutNulls,
  );

  return firestoreData;
}

class NpsMetricsRecordDocumentEquality implements Equality<NpsMetricsRecord> {
  const NpsMetricsRecordDocumentEquality();

  @override
  bool equals(NpsMetricsRecord? e1, NpsMetricsRecord? e2) {
    return e1?.npsScore == e2?.npsScore && e1?.npsComment == e2?.npsComment;
  }

  @override
  int hash(NpsMetricsRecord? e) =>
      const ListEquality().hash([e?.npsScore, e?.npsComment]);

  @override
  bool isValidKey(Object? o) => o is NpsMetricsRecord;
}
