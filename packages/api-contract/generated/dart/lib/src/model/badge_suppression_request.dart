//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'badge_suppression_request.g.dart';

/// Display suppression for a documented fraud or compliance case. There is no award command.
///
/// Properties:
/// * [badgeCode]
/// * [reasonCode]
/// * [caseReference]
/// * [note]
@BuiltValue()
abstract class BadgeSuppressionRequest implements Built<BadgeSuppressionRequest, BadgeSuppressionRequestBuilder> {
  @BuiltValueField(wireName: r'badge_code')
  BadgeSuppressionRequestBadgeCodeEnum get badgeCode;
  // enum badgeCodeEnum {  FAST_RESPONDER,  ON_TIME,  MOST_ORDERED,  HIGHLY_RATED,  HIGH_QUALITY_MATERIALS,  TRUSTED_SUPPLIER,  };

  @BuiltValueField(wireName: r'reason_code')
  BadgeSuppressionRequestReasonCodeEnum get reasonCode;
  // enum reasonCodeEnum {  FRAUD,  COMPLIANCE,  };

  @BuiltValueField(wireName: r'case_reference')
  String get caseReference;

  @BuiltValueField(wireName: r'note')
  String get note;

  BadgeSuppressionRequest._();

  factory BadgeSuppressionRequest([void updates(BadgeSuppressionRequestBuilder b)]) = _$BadgeSuppressionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BadgeSuppressionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BadgeSuppressionRequest> get serializer => _$BadgeSuppressionRequestSerializer();
}

class _$BadgeSuppressionRequestSerializer implements PrimitiveSerializer<BadgeSuppressionRequest> {
  @override
  final Iterable<Type> types = const [BadgeSuppressionRequest, _$BadgeSuppressionRequest];

  @override
  final String wireName = r'BadgeSuppressionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BadgeSuppressionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'badge_code';
    yield serializers.serialize(
      object.badgeCode,
      specifiedType: const FullType(BadgeSuppressionRequestBadgeCodeEnum),
    );
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(BadgeSuppressionRequestReasonCodeEnum),
    );
    yield r'case_reference';
    yield serializers.serialize(
      object.caseReference,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BadgeSuppressionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BadgeSuppressionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'badge_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BadgeSuppressionRequestBadgeCodeEnum),
          ) as BadgeSuppressionRequestBadgeCodeEnum;
          result.badgeCode = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BadgeSuppressionRequestReasonCodeEnum),
          ) as BadgeSuppressionRequestReasonCodeEnum;
          result.reasonCode = valueDes;
          break;
        case r'case_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.caseReference = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BadgeSuppressionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BadgeSuppressionRequestBuilder();
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


class BadgeSuppressionRequestBadgeCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAST_RESPONDER')
  static const BadgeSuppressionRequestBadgeCodeEnum FAST_RESPONDER = _$badgeSuppressionRequestBadgeCodeEnum_FAST_RESPONDER;
  @BuiltValueEnumConst(wireName: r'ON_TIME')
  static const BadgeSuppressionRequestBadgeCodeEnum ON_TIME = _$badgeSuppressionRequestBadgeCodeEnum_ON_TIME;
  @BuiltValueEnumConst(wireName: r'MOST_ORDERED')
  static const BadgeSuppressionRequestBadgeCodeEnum MOST_ORDERED = _$badgeSuppressionRequestBadgeCodeEnum_MOST_ORDERED;
  @BuiltValueEnumConst(wireName: r'HIGHLY_RATED')
  static const BadgeSuppressionRequestBadgeCodeEnum HIGHLY_RATED = _$badgeSuppressionRequestBadgeCodeEnum_HIGHLY_RATED;
  @BuiltValueEnumConst(wireName: r'HIGH_QUALITY_MATERIALS')
  static const BadgeSuppressionRequestBadgeCodeEnum HIGH_QUALITY_MATERIALS = _$badgeSuppressionRequestBadgeCodeEnum_HIGH_QUALITY_MATERIALS;
  @BuiltValueEnumConst(wireName: r'TRUSTED_SUPPLIER')
  static const BadgeSuppressionRequestBadgeCodeEnum TRUSTED_SUPPLIER = _$badgeSuppressionRequestBadgeCodeEnum_TRUSTED_SUPPLIER;

  static Serializer<BadgeSuppressionRequestBadgeCodeEnum> get serializer => _$badgeSuppressionRequestBadgeCodeEnumSerializer;

  const BadgeSuppressionRequestBadgeCodeEnum._(String name): super(name);

  static BuiltSet<BadgeSuppressionRequestBadgeCodeEnum> get values => _$badgeSuppressionRequestBadgeCodeEnumValues;
  static BadgeSuppressionRequestBadgeCodeEnum valueOf(String name) => _$badgeSuppressionRequestBadgeCodeEnumValueOf(name);
}

class BadgeSuppressionRequestReasonCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FRAUD')
  static const BadgeSuppressionRequestReasonCodeEnum FRAUD = _$badgeSuppressionRequestReasonCodeEnum_FRAUD;
  @BuiltValueEnumConst(wireName: r'COMPLIANCE')
  static const BadgeSuppressionRequestReasonCodeEnum COMPLIANCE = _$badgeSuppressionRequestReasonCodeEnum_COMPLIANCE;

  static Serializer<BadgeSuppressionRequestReasonCodeEnum> get serializer => _$badgeSuppressionRequestReasonCodeEnumSerializer;

  const BadgeSuppressionRequestReasonCodeEnum._(String name): super(name);

  static BuiltSet<BadgeSuppressionRequestReasonCodeEnum> get values => _$badgeSuppressionRequestReasonCodeEnumValues;
  static BadgeSuppressionRequestReasonCodeEnum valueOf(String name) => _$badgeSuppressionRequestReasonCodeEnumValueOf(name);
}

