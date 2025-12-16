import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GreetingsForAIPromptRecord extends FirestoreRecord {
  GreetingsForAIPromptRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "greeting_number" field.
  int? _greetingNumber;
  int get greetingNumber => _greetingNumber ?? 0;
  bool hasGreetingNumber() => _greetingNumber != null;

  // "greeting_text" field.
  String? _greetingText;
  String get greetingText => _greetingText ?? '';
  bool hasGreetingText() => _greetingText != null;

  void _initializeFields() {
    _greetingNumber = castToType<int>(snapshotData['greeting_number']);
    _greetingText = snapshotData['greeting_text'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('greetingsForAIPrompt');

  static Stream<GreetingsForAIPromptRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => GreetingsForAIPromptRecord.fromSnapshot(s));

  static Future<GreetingsForAIPromptRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => GreetingsForAIPromptRecord.fromSnapshot(s));

  static GreetingsForAIPromptRecord fromSnapshot(DocumentSnapshot snapshot) =>
      GreetingsForAIPromptRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GreetingsForAIPromptRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GreetingsForAIPromptRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GreetingsForAIPromptRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GreetingsForAIPromptRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGreetingsForAIPromptRecordData({
  int? greetingNumber,
  String? greetingText,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'greeting_number': greetingNumber,
      'greeting_text': greetingText,
    }.withoutNulls,
  );

  return firestoreData;
}

class GreetingsForAIPromptRecordDocumentEquality
    implements Equality<GreetingsForAIPromptRecord> {
  const GreetingsForAIPromptRecordDocumentEquality();

  @override
  bool equals(GreetingsForAIPromptRecord? e1, GreetingsForAIPromptRecord? e2) {
    return e1?.greetingNumber == e2?.greetingNumber &&
        e1?.greetingText == e2?.greetingText;
  }

  @override
  int hash(GreetingsForAIPromptRecord? e) =>
      const ListEquality().hash([e?.greetingNumber, e?.greetingText]);

  @override
  bool isValidKey(Object? o) => o is GreetingsForAIPromptRecord;
}
