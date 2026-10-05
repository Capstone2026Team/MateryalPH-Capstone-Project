//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_badge.g.dart';

/// An active automatic badge, shown as text plus an icon. Admin-suppressed badges are omitted.
///
/// Properties:
/// * [code]
/// * [name]
/// * [scopeLabel]
/// * [description]
/// * [earnedAt]
@BuiltValue()
abstract class PublicBadge implements Built<PublicBadge, PublicBadgeBuilder> {
  @BuiltValueField(wireName: r'code')
  PublicBadgeCodeEnum get code;
  // enum codeEnum {  FAST_RESPONDER,  ON_TIME,  MOST_ORDERED,  HIGHLY_RATED,  HIGH_QUALITY_MATERIALS,  TRUSTED_SUPPLIER,  BEST_PRICE,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'scope_label')
  String? get scopeLabel;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'earned_at')
  DateTime get earnedAt;

  PublicBadge._();

  factory PublicBadge([void updates(PublicBadgeBuilder b)]) = _$PublicBadge;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicBadgeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicBadge> get serializer => _$PublicBadgeSerializer();
}

class _$PublicBadgeSerializer implements PrimitiveSerializer<PublicBadge> {
  @override
  final Iterable<Type> types = const [PublicBadge, _$PublicBadge];

  @override
  final String wireName = r'PublicBadge';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicBadge object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(PublicBadgeCodeEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.scopeLabel != null) {
      yield r'scope_label';
      yield serializers.serialize(
        object.scopeLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'earned_at';
    yield serializers.serialize(
      object.earnedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicBadge object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicBadgeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicBadgeCodeEnum),
          ) as PublicBadgeCodeEnum;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'scope_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scopeLabel = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'earned_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.earnedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicBadge deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicBadgeBuilder();
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


class PublicBadgeCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAST_RESPONDER')
  static const PublicBadgeCodeEnum FAST_RESPONDER = _$publicBadgeCodeEnum_FAST_RESPONDER;
  @BuiltValueEnumConst(wireName: r'ON_TIME')
  static const PublicBadgeCodeEnum ON_TIME = _$publicBadgeCodeEnum_ON_TIME;
  @BuiltValueEnumConst(wireName: r'MOST_ORDERED')
  static const PublicBadgeCodeEnum MOST_ORDERED = _$publicBadgeCodeEnum_MOST_ORDERED;
  @BuiltValueEnumConst(wireName: r'HIGHLY_RATED')
  static const PublicBadgeCodeEnum HIGHLY_RATED = _$publicBadgeCodeEnum_HIGHLY_RATED;
  @BuiltValueEnumConst(wireName: r'HIGH_QUALITY_MATERIALS')
  static const PublicBadgeCodeEnum HIGH_QUALITY_MATERIALS = _$publicBadgeCodeEnum_HIGH_QUALITY_MATERIALS;
  @BuiltValueEnumConst(wireName: r'TRUSTED_SUPPLIER')
  static const PublicBadgeCodeEnum TRUSTED_SUPPLIER = _$publicBadgeCodeEnum_TRUSTED_SUPPLIER;
  @BuiltValueEnumConst(wireName: r'BEST_PRICE')
  static const PublicBadgeCodeEnum BEST_PRICE = _$publicBadgeCodeEnum_BEST_PRICE;

  static Serializer<PublicBadgeCodeEnum> get serializer => _$publicBadgeCodeEnumSerializer;

  const PublicBadgeCodeEnum._(String name): super(name);

  static BuiltSet<PublicBadgeCodeEnum> get values => _$publicBadgeCodeEnumValues;
  static PublicBadgeCodeEnum valueOf(String name) => _$publicBadgeCodeEnumValueOf(name);
}

