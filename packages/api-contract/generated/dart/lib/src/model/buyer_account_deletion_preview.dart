//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_account_retained_record.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/buyer_account_deletion_blockers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_account_deletion_preview.g.dart';

/// BuyerAccountDeletionPreview
///
/// Properties:
/// * [canDelete]
/// * [blockers]
/// * [retainedRecords]
/// * [confirmationPhrase]
@BuiltValue()
abstract class BuyerAccountDeletionPreview implements Built<BuyerAccountDeletionPreview, BuyerAccountDeletionPreviewBuilder> {
  @BuiltValueField(wireName: r'can_delete')
  bool get canDelete;

  @BuiltValueField(wireName: r'blockers')
  BuyerAccountDeletionBlockers get blockers;

  @BuiltValueField(wireName: r'retained_records')
  BuiltList<BuyerAccountRetainedRecord> get retainedRecords;

  @BuiltValueField(wireName: r'confirmation_phrase')
  String get confirmationPhrase;

  BuyerAccountDeletionPreview._();

  factory BuyerAccountDeletionPreview([void updates(BuyerAccountDeletionPreviewBuilder b)]) = _$BuyerAccountDeletionPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAccountDeletionPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAccountDeletionPreview> get serializer => _$BuyerAccountDeletionPreviewSerializer();
}

class _$BuyerAccountDeletionPreviewSerializer implements PrimitiveSerializer<BuyerAccountDeletionPreview> {
  @override
  final Iterable<Type> types = const [BuyerAccountDeletionPreview, _$BuyerAccountDeletionPreview];

  @override
  final String wireName = r'BuyerAccountDeletionPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAccountDeletionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_delete';
    yield serializers.serialize(
      object.canDelete,
      specifiedType: const FullType(bool),
    );
    yield r'blockers';
    yield serializers.serialize(
      object.blockers,
      specifiedType: const FullType(BuyerAccountDeletionBlockers),
    );
    yield r'retained_records';
    yield serializers.serialize(
      object.retainedRecords,
      specifiedType: const FullType(BuiltList, [FullType(BuyerAccountRetainedRecord)]),
    );
    yield r'confirmation_phrase';
    yield serializers.serialize(
      object.confirmationPhrase,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAccountDeletionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAccountDeletionPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_delete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canDelete = valueDes;
          break;
        case r'blockers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAccountDeletionBlockers),
          ) as BuyerAccountDeletionBlockers;
          result.blockers.replace(valueDes);
          break;
        case r'retained_records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyerAccountRetainedRecord)]),
          ) as BuiltList<BuyerAccountRetainedRecord>;
          result.retainedRecords.replace(valueDes);
          break;
        case r'confirmation_phrase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.confirmationPhrase = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAccountDeletionPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAccountDeletionPreviewBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


