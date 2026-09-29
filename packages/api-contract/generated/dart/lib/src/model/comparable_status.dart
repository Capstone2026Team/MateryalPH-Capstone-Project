//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comparable_status.g.dart';

/// ComparableStatus
///
/// Properties:
/// * [status]
/// * [normalizedUnitPrice] - MAT-03 PHP per canonical unit as a decimal string.
/// * [canonicalUnitCode]
@BuiltValue()
abstract class ComparableStatus implements Built<ComparableStatus, ComparableStatusBuilder> {
  @BuiltValueField(wireName: r'status')
  ComparableStatusStatusEnum get status;
  // enum statusEnum {  COMPARABLE,  NOT_YET_COMPARABLE,  };

  /// MAT-03 PHP per canonical unit as a decimal string.
  @BuiltValueField(wireName: r'normalized_unit_price')
  String? get normalizedUnitPrice;

  @BuiltValueField(wireName: r'canonical_unit_code')
  String? get canonicalUnitCode;

  ComparableStatus._();

  factory ComparableStatus([void updates(ComparableStatusBuilder b)]) = _$ComparableStatus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComparableStatusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComparableStatus> get serializer => _$ComparableStatusSerializer();
}

class _$ComparableStatusSerializer implements PrimitiveSerializer<ComparableStatus> {
  @override
  final Iterable<Type> types = const [ComparableStatus, _$ComparableStatus];

  @override
  final String wireName = r'ComparableStatus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComparableStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ComparableStatusStatusEnum),
    );
    yield r'normalized_unit_price';
    yield object.normalizedUnitPrice == null ? null : serializers.serialize(
      object.normalizedUnitPrice,
      specifiedType: const FullType.nullable(String),
    );
    yield r'canonical_unit_code';
    yield object.canonicalUnitCode == null ? null : serializers.serialize(
      object.canonicalUnitCode,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComparableStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComparableStatusBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComparableStatusStatusEnum),
          ) as ComparableStatusStatusEnum;
          result.status = valueDes;
          break;
        case r'normalized_unit_price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.normalizedUnitPrice = valueDes;
          break;
        case r'canonical_unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.canonicalUnitCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComparableStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComparableStatusBuilder();
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


class ComparableStatusStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPARABLE')
  static const ComparableStatusStatusEnum COMPARABLE = _$comparableStatusStatusEnum_COMPARABLE;
  @BuiltValueEnumConst(wireName: r'NOT_YET_COMPARABLE')
  static const ComparableStatusStatusEnum NOT_YET_COMPARABLE = _$comparableStatusStatusEnum_NOT_YET_COMPARABLE;

  static Serializer<ComparableStatusStatusEnum> get serializer => _$comparableStatusStatusEnumSerializer;

  const ComparableStatusStatusEnum._(String name): super(name);

  static BuiltSet<ComparableStatusStatusEnum> get values => _$comparableStatusStatusEnumValues;
  static ComparableStatusStatusEnum valueOf(String name) => _$comparableStatusStatusEnumValueOf(name);
}

