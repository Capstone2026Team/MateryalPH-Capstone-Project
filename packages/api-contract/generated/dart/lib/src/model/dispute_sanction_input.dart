//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_sanction_input.g.dart';

/// A warning takes effect when the decision is final; restriction, suspension and ban are recorded and referred to User Management Staff.
///
/// Properties:
/// * [subject]
/// * [action]
/// * [reason]
/// * [scope]
/// * [durationDays]
/// * [restorationCondition]
@BuiltValue()
abstract class DisputeSanctionInput implements Built<DisputeSanctionInput, DisputeSanctionInputBuilder> {
  @BuiltValueField(wireName: r'subject')
  DisputeSanctionInputSubjectEnum get subject;
  // enum subjectEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'action')
  DisputeSanctionInputActionEnum get action;
  // enum actionEnum {  WARNING,  TEMPORARY_RESTRICTION,  SUSPENSION,  PERMANENT_BAN,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'scope')
  String? get scope;

  @BuiltValueField(wireName: r'duration_days')
  int? get durationDays;

  @BuiltValueField(wireName: r'restoration_condition')
  String? get restorationCondition;

  DisputeSanctionInput._();

  factory DisputeSanctionInput([void updates(DisputeSanctionInputBuilder b)]) = _$DisputeSanctionInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeSanctionInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeSanctionInput> get serializer => _$DisputeSanctionInputSerializer();
}

class _$DisputeSanctionInputSerializer implements PrimitiveSerializer<DisputeSanctionInput> {
  @override
  final Iterable<Type> types = const [DisputeSanctionInput, _$DisputeSanctionInput];

  @override
  final String wireName = r'DisputeSanctionInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeSanctionInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(DisputeSanctionInputSubjectEnum),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(DisputeSanctionInputActionEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.scope != null) {
      yield r'scope';
      yield serializers.serialize(
        object.scope,
        specifiedType: const FullType(String),
      );
    }
    if (object.durationDays != null) {
      yield r'duration_days';
      yield serializers.serialize(
        object.durationDays,
        specifiedType: const FullType(int),
      );
    }
    if (object.restorationCondition != null) {
      yield r'restoration_condition';
      yield serializers.serialize(
        object.restorationCondition,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeSanctionInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeSanctionInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeSanctionInputSubjectEnum),
          ) as DisputeSanctionInputSubjectEnum;
          result.subject = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeSanctionInputActionEnum),
          ) as DisputeSanctionInputActionEnum;
          result.action = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scope = valueDes;
          break;
        case r'duration_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationDays = valueDes;
          break;
        case r'restoration_condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.restorationCondition = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeSanctionInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeSanctionInputBuilder();
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


class DisputeSanctionInputSubjectEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeSanctionInputSubjectEnum BUYER = _$disputeSanctionInputSubjectEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeSanctionInputSubjectEnum VENDOR = _$disputeSanctionInputSubjectEnum_VENDOR;

  static Serializer<DisputeSanctionInputSubjectEnum> get serializer => _$disputeSanctionInputSubjectEnumSerializer;

  const DisputeSanctionInputSubjectEnum._(String name): super(name);

  static BuiltSet<DisputeSanctionInputSubjectEnum> get values => _$disputeSanctionInputSubjectEnumValues;
  static DisputeSanctionInputSubjectEnum valueOf(String name) => _$disputeSanctionInputSubjectEnumValueOf(name);
}

class DisputeSanctionInputActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WARNING')
  static const DisputeSanctionInputActionEnum WARNING = _$disputeSanctionInputActionEnum_WARNING;
  @BuiltValueEnumConst(wireName: r'TEMPORARY_RESTRICTION')
  static const DisputeSanctionInputActionEnum TEMPORARY_RESTRICTION = _$disputeSanctionInputActionEnum_TEMPORARY_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'SUSPENSION')
  static const DisputeSanctionInputActionEnum SUSPENSION = _$disputeSanctionInputActionEnum_SUSPENSION;
  @BuiltValueEnumConst(wireName: r'PERMANENT_BAN')
  static const DisputeSanctionInputActionEnum PERMANENT_BAN = _$disputeSanctionInputActionEnum_PERMANENT_BAN;

  static Serializer<DisputeSanctionInputActionEnum> get serializer => _$disputeSanctionInputActionEnumSerializer;

  const DisputeSanctionInputActionEnum._(String name): super(name);

  static BuiltSet<DisputeSanctionInputActionEnum> get values => _$disputeSanctionInputActionEnumValues;
  static DisputeSanctionInputActionEnum valueOf(String name) => _$disputeSanctionInputActionEnumValueOf(name);
}

