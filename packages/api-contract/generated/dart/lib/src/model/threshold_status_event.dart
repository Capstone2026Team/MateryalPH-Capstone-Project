//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'threshold_status_event.g.dart';

/// ThresholdStatusEvent
///
/// Properties:
/// * [fromStatus]
/// * [toStatus]
/// * [reasonCode]
/// * [gBeforeCentavos]
/// * [gAfterCentavos]
/// * [actorType]
/// * [occurredAt]
@BuiltValue()
abstract class ThresholdStatusEvent implements Built<ThresholdStatusEvent, ThresholdStatusEventBuilder> {
  @BuiltValueField(wireName: r'from_status')
  ThresholdStatusEventFromStatusEnum? get fromStatus;
  // enum fromStatusEnum {  RELIEF_ACTIVE,  SUBJECT_STANDARD,  SUBJECT_THRESHOLD_BREACHED,  SUBJECT_PRIOR_YEAR,  UNDER_REVIEW,  };

  @BuiltValueField(wireName: r'to_status')
  ThresholdStatusEventToStatusEnum get toStatus;
  // enum toStatusEnum {  RELIEF_ACTIVE,  SUBJECT_STANDARD,  SUBJECT_THRESHOLD_BREACHED,  SUBJECT_PRIOR_YEAR,  UNDER_REVIEW,  };

  @BuiltValueField(wireName: r'reason_code')
  String get reasonCode;

  @BuiltValueField(wireName: r'g_before_centavos')
  int get gBeforeCentavos;

  @BuiltValueField(wireName: r'g_after_centavos')
  int get gAfterCentavos;

  @BuiltValueField(wireName: r'actor_type')
  ThresholdStatusEventActorTypeEnum get actorType;
  // enum actorTypeEnum {  SYSTEM,  ADMIN,  VENDOR,  };

  @BuiltValueField(wireName: r'occurred_at')
  DateTime? get occurredAt;

  ThresholdStatusEvent._();

  factory ThresholdStatusEvent([void updates(ThresholdStatusEventBuilder b)]) = _$ThresholdStatusEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ThresholdStatusEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ThresholdStatusEvent> get serializer => _$ThresholdStatusEventSerializer();
}

class _$ThresholdStatusEventSerializer implements PrimitiveSerializer<ThresholdStatusEvent> {
  @override
  final Iterable<Type> types = const [ThresholdStatusEvent, _$ThresholdStatusEvent];

  @override
  final String wireName = r'ThresholdStatusEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ThresholdStatusEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fromStatus != null) {
      yield r'from_status';
      yield serializers.serialize(
        object.fromStatus,
        specifiedType: const FullType(ThresholdStatusEventFromStatusEnum),
      );
    }
    yield r'to_status';
    yield serializers.serialize(
      object.toStatus,
      specifiedType: const FullType(ThresholdStatusEventToStatusEnum),
    );
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(String),
    );
    yield r'g_before_centavos';
    yield serializers.serialize(
      object.gBeforeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'g_after_centavos';
    yield serializers.serialize(
      object.gAfterCentavos,
      specifiedType: const FullType(int),
    );
    yield r'actor_type';
    yield serializers.serialize(
      object.actorType,
      specifiedType: const FullType(ThresholdStatusEventActorTypeEnum),
    );
    if (object.occurredAt != null) {
      yield r'occurred_at';
      yield serializers.serialize(
        object.occurredAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ThresholdStatusEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ThresholdStatusEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ThresholdStatusEventFromStatusEnum),
          ) as ThresholdStatusEventFromStatusEnum?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'to_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ThresholdStatusEventToStatusEnum),
          ) as ThresholdStatusEventToStatusEnum;
          result.toStatus = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reasonCode = valueDes;
          break;
        case r'g_before_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gBeforeCentavos = valueDes;
          break;
        case r'g_after_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gAfterCentavos = valueDes;
          break;
        case r'actor_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ThresholdStatusEventActorTypeEnum),
          ) as ThresholdStatusEventActorTypeEnum;
          result.actorType = valueDes;
          break;
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.occurredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ThresholdStatusEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ThresholdStatusEventBuilder();
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


class ThresholdStatusEventFromStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RELIEF_ACTIVE')
  static const ThresholdStatusEventFromStatusEnum RELIEF_ACTIVE = _$thresholdStatusEventFromStatusEnum_RELIEF_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUBJECT_STANDARD')
  static const ThresholdStatusEventFromStatusEnum SUBJECT_STANDARD = _$thresholdStatusEventFromStatusEnum_SUBJECT_STANDARD;
  @BuiltValueEnumConst(wireName: r'SUBJECT_THRESHOLD_BREACHED')
  static const ThresholdStatusEventFromStatusEnum SUBJECT_THRESHOLD_BREACHED = _$thresholdStatusEventFromStatusEnum_SUBJECT_THRESHOLD_BREACHED;
  @BuiltValueEnumConst(wireName: r'SUBJECT_PRIOR_YEAR')
  static const ThresholdStatusEventFromStatusEnum SUBJECT_PRIOR_YEAR = _$thresholdStatusEventFromStatusEnum_SUBJECT_PRIOR_YEAR;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const ThresholdStatusEventFromStatusEnum UNDER_REVIEW = _$thresholdStatusEventFromStatusEnum_UNDER_REVIEW;

  static Serializer<ThresholdStatusEventFromStatusEnum> get serializer => _$thresholdStatusEventFromStatusEnumSerializer;

  const ThresholdStatusEventFromStatusEnum._(String name): super(name);

  static BuiltSet<ThresholdStatusEventFromStatusEnum> get values => _$thresholdStatusEventFromStatusEnumValues;
  static ThresholdStatusEventFromStatusEnum valueOf(String name) => _$thresholdStatusEventFromStatusEnumValueOf(name);
}

class ThresholdStatusEventToStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RELIEF_ACTIVE')
  static const ThresholdStatusEventToStatusEnum RELIEF_ACTIVE = _$thresholdStatusEventToStatusEnum_RELIEF_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUBJECT_STANDARD')
  static const ThresholdStatusEventToStatusEnum SUBJECT_STANDARD = _$thresholdStatusEventToStatusEnum_SUBJECT_STANDARD;
  @BuiltValueEnumConst(wireName: r'SUBJECT_THRESHOLD_BREACHED')
  static const ThresholdStatusEventToStatusEnum SUBJECT_THRESHOLD_BREACHED = _$thresholdStatusEventToStatusEnum_SUBJECT_THRESHOLD_BREACHED;
  @BuiltValueEnumConst(wireName: r'SUBJECT_PRIOR_YEAR')
  static const ThresholdStatusEventToStatusEnum SUBJECT_PRIOR_YEAR = _$thresholdStatusEventToStatusEnum_SUBJECT_PRIOR_YEAR;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const ThresholdStatusEventToStatusEnum UNDER_REVIEW = _$thresholdStatusEventToStatusEnum_UNDER_REVIEW;

  static Serializer<ThresholdStatusEventToStatusEnum> get serializer => _$thresholdStatusEventToStatusEnumSerializer;

  const ThresholdStatusEventToStatusEnum._(String name): super(name);

  static BuiltSet<ThresholdStatusEventToStatusEnum> get values => _$thresholdStatusEventToStatusEnumValues;
  static ThresholdStatusEventToStatusEnum valueOf(String name) => _$thresholdStatusEventToStatusEnumValueOf(name);
}

class ThresholdStatusEventActorTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const ThresholdStatusEventActorTypeEnum SYSTEM = _$thresholdStatusEventActorTypeEnum_SYSTEM;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const ThresholdStatusEventActorTypeEnum ADMIN = _$thresholdStatusEventActorTypeEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const ThresholdStatusEventActorTypeEnum VENDOR = _$thresholdStatusEventActorTypeEnum_VENDOR;

  static Serializer<ThresholdStatusEventActorTypeEnum> get serializer => _$thresholdStatusEventActorTypeEnumSerializer;

  const ThresholdStatusEventActorTypeEnum._(String name): super(name);

  static BuiltSet<ThresholdStatusEventActorTypeEnum> get values => _$thresholdStatusEventActorTypeEnumValues;
  static ThresholdStatusEventActorTypeEnum valueOf(String name) => _$thresholdStatusEventActorTypeEnumValueOf(name);
}

