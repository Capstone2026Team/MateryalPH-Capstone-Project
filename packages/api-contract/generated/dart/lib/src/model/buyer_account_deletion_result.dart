//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_account_deletion_result.g.dart';

/// BuyerAccountDeletionResult
///
/// Properties:
/// * [reference] - Account-deletion reference recorded in the audit trail for follow-up with support.
/// * [deletedAt]
/// * [signInRequired]
@BuiltValue()
abstract class BuyerAccountDeletionResult implements Built<BuyerAccountDeletionResult, BuyerAccountDeletionResultBuilder> {
  /// Account-deletion reference recorded in the audit trail for follow-up with support.
  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'deleted_at')
  DateTime get deletedAt;

  @BuiltValueField(wireName: r'sign_in_required')
  bool get signInRequired;

  BuyerAccountDeletionResult._();

  factory BuyerAccountDeletionResult([void updates(BuyerAccountDeletionResultBuilder b)]) = _$BuyerAccountDeletionResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAccountDeletionResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAccountDeletionResult> get serializer => _$BuyerAccountDeletionResultSerializer();
}

class _$BuyerAccountDeletionResultSerializer implements PrimitiveSerializer<BuyerAccountDeletionResult> {
  @override
  final Iterable<Type> types = const [BuyerAccountDeletionResult, _$BuyerAccountDeletionResult];

  @override
  final String wireName = r'BuyerAccountDeletionResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAccountDeletionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'deleted_at';
    yield serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'sign_in_required';
    yield serializers.serialize(
      object.signInRequired,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAccountDeletionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAccountDeletionResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'deleted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deletedAt = valueDes;
          break;
        case r'sign_in_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.signInRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAccountDeletionResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAccountDeletionResultBuilder();
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


