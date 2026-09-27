//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comparable_group_create.g.dart';

/// ComparableGroupCreate
///
/// Properties:
/// * [materialId]
/// * [code]
/// * [displayName]
/// * [brand]
/// * [model]
/// * [specification]
/// * [canonicalUnitId]
/// * [conversionVersion]
@BuiltValue()
abstract class ComparableGroupCreate implements Built<ComparableGroupCreate, ComparableGroupCreateBuilder> {
  @BuiltValueField(wireName: r'material_id')
  String get materialId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'model')
  String? get model;

  @BuiltValueField(wireName: r'specification')
  BuiltMap<String, String> get specification;

  @BuiltValueField(wireName: r'canonical_unit_id')
  String get canonicalUnitId;

  @BuiltValueField(wireName: r'conversion_version')
  String? get conversionVersion;

  ComparableGroupCreate._();

  factory ComparableGroupCreate([void updates(ComparableGroupCreateBuilder b)]) = _$ComparableGroupCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComparableGroupCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComparableGroupCreate> get serializer => _$ComparableGroupCreateSerializer();
}

class _$ComparableGroupCreateSerializer implements PrimitiveSerializer<ComparableGroupCreate> {
  @override
  final Iterable<Type> types = const [ComparableGroupCreate, _$ComparableGroupCreate];

  @override
  final String wireName = r'ComparableGroupCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComparableGroupCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'material_id';
    yield serializers.serialize(
      object.materialId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.model != null) {
      yield r'model';
      yield serializers.serialize(
        object.model,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'specification';
    yield serializers.serialize(
      object.specification,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    yield r'canonical_unit_id';
    yield serializers.serialize(
      object.canonicalUnitId,
      specifiedType: const FullType(String),
    );
    if (object.conversionVersion != null) {
      yield r'conversion_version';
      yield serializers.serialize(
        object.conversionVersion,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ComparableGroupCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComparableGroupCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'material_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.materialId = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model = valueDes;
          break;
        case r'specification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.specification.replace(valueDes);
          break;
        case r'canonical_unit_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.canonicalUnitId = valueDes;
          break;
        case r'conversion_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.conversionVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComparableGroupCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComparableGroupCreateBuilder();
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


