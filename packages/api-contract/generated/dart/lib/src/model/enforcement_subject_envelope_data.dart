//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/subject_review.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/enforcement_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_subject_envelope_data.g.dart';

/// EnforcementSubjectEnvelopeData
///
/// Properties:
/// * [subjectType]
/// * [subjectId]
/// * [displayName]
/// * [maskedEmail]
/// * [accountStatus]
/// * [storeActivationStatus]
/// * [openOrders]
/// * [ordersTotal]
/// * [disputesTotal]
/// * [disputesOpen]
/// * [commerceRestrictedUntil]
/// * [sanctions]
@BuiltValue()
abstract class EnforcementSubjectEnvelopeData implements SubjectReview, Built<EnforcementSubjectEnvelopeData, EnforcementSubjectEnvelopeDataBuilder> {
  @BuiltValueField(wireName: r'sanctions')
  BuiltList<EnforcementSummary> get sanctions;

  EnforcementSubjectEnvelopeData._();

  factory EnforcementSubjectEnvelopeData([void updates(EnforcementSubjectEnvelopeDataBuilder b)]) = _$EnforcementSubjectEnvelopeData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementSubjectEnvelopeDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementSubjectEnvelopeData> get serializer => _$EnforcementSubjectEnvelopeDataSerializer();
}

class _$EnforcementSubjectEnvelopeDataSerializer implements PrimitiveSerializer<EnforcementSubjectEnvelopeData> {
  @override
  final Iterable<Type> types = const [EnforcementSubjectEnvelopeData, _$EnforcementSubjectEnvelopeData];

  @override
  final String wireName = r'EnforcementSubjectEnvelopeData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementSubjectEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.accountStatus != null) {
      yield r'account_status';
      yield serializers.serialize(
        object.accountStatus,
        specifiedType: const FullType(String),
      );
    }
    if (object.storeActivationStatus != null) {
      yield r'store_activation_status';
      yield serializers.serialize(
        object.storeActivationStatus,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.ordersTotal != null) {
      yield r'orders_total';
      yield serializers.serialize(
        object.ordersTotal,
        specifiedType: const FullType(int),
      );
    }
    if (object.maskedEmail != null) {
      yield r'masked_email';
      yield serializers.serialize(
        object.maskedEmail,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.disputesOpen != null) {
      yield r'disputes_open';
      yield serializers.serialize(
        object.disputesOpen,
        specifiedType: const FullType(int),
      );
    }
    if (object.disputesTotal != null) {
      yield r'disputes_total';
      yield serializers.serialize(
        object.disputesTotal,
        specifiedType: const FullType(int),
      );
    }
    if (object.commerceRestrictedUntil != null) {
      yield r'commerce_restricted_until';
      yield serializers.serialize(
        object.commerceRestrictedUntil,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'sanctions';
    yield serializers.serialize(
      object.sanctions,
      specifiedType: const FullType(BuiltList, [FullType(EnforcementSummary)]),
    );
    if (object.subjectType != null) {
      yield r'subject_type';
      yield serializers.serialize(
        object.subjectType,
        specifiedType: const FullType(String),
      );
    }
    if (object.subjectId != null) {
      yield r'subject_id';
      yield serializers.serialize(
        object.subjectId,
        specifiedType: const FullType(String),
      );
    }
    if (object.openOrders != null) {
      yield r'open_orders';
      yield serializers.serialize(
        object.openOrders,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementSubjectEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementSubjectEnvelopeDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'account_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountStatus = valueDes;
          break;
        case r'store_activation_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeActivationStatus = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'orders_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ordersTotal = valueDes;
          break;
        case r'masked_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.maskedEmail = valueDes;
          break;
        case r'disputes_open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.disputesOpen = valueDes;
          break;
        case r'disputes_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.disputesTotal = valueDes;
          break;
        case r'commerce_restricted_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.commerceRestrictedUntil = valueDes;
          break;
        case r'sanctions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EnforcementSummary)]),
          ) as BuiltList<EnforcementSummary>;
          result.sanctions.replace(valueDes);
          break;
        case r'subject_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subjectType = valueDes;
          break;
        case r'subject_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subjectId = valueDes;
          break;
        case r'open_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.openOrders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnforcementSubjectEnvelopeData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementSubjectEnvelopeDataBuilder();
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


