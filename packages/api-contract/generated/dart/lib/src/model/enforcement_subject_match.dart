//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_subject_match.g.dart';

/// EnforcementSubjectMatch
///
/// Properties:
/// * [type]
/// * [id]
/// * [displayName]
/// * [status]
@BuiltValue()
abstract class EnforcementSubjectMatch implements Built<EnforcementSubjectMatch, EnforcementSubjectMatchBuilder> {
  @BuiltValueField(wireName: r'type')
  EnforcementSubjectMatchTypeEnum get type;
  // enum typeEnum {  BUYER,  VENDOR_ORGANIZATION,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'status')
  String get status;

  EnforcementSubjectMatch._();

  factory EnforcementSubjectMatch([void updates(EnforcementSubjectMatchBuilder b)]) = _$EnforcementSubjectMatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementSubjectMatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementSubjectMatch> get serializer => _$EnforcementSubjectMatchSerializer();
}

class _$EnforcementSubjectMatchSerializer implements PrimitiveSerializer<EnforcementSubjectMatch> {
  @override
  final Iterable<Type> types = const [EnforcementSubjectMatch, _$EnforcementSubjectMatch];

  @override
  final String wireName = r'EnforcementSubjectMatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementSubjectMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(EnforcementSubjectMatchTypeEnum),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementSubjectMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementSubjectMatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSubjectMatchTypeEnum),
          ) as EnforcementSubjectMatchTypeEnum;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnforcementSubjectMatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementSubjectMatchBuilder();
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


class EnforcementSubjectMatchTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const EnforcementSubjectMatchTypeEnum BUYER = _$enforcementSubjectMatchTypeEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR_ORGANIZATION')
  static const EnforcementSubjectMatchTypeEnum VENDOR_ORGANIZATION = _$enforcementSubjectMatchTypeEnum_VENDOR_ORGANIZATION;

  static Serializer<EnforcementSubjectMatchTypeEnum> get serializer => _$enforcementSubjectMatchTypeEnumSerializer;

  const EnforcementSubjectMatchTypeEnum._(String name): super(name);

  static BuiltSet<EnforcementSubjectMatchTypeEnum> get values => _$enforcementSubjectMatchTypeEnumValues;
  static EnforcementSubjectMatchTypeEnum valueOf(String name) => _$enforcementSubjectMatchTypeEnumValueOf(name);
}

