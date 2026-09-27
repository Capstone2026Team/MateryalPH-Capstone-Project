//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_unit.g.dart';

/// CatalogUnit
///
/// Properties:
/// * [id]
/// * [code]
/// * [name]
/// * [dimension]
/// * [precision]
@BuiltValue()
abstract class CatalogUnit implements Built<CatalogUnit, CatalogUnitBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'dimension')
  String get dimension;

  @BuiltValueField(wireName: r'precision')
  int get precision;

  CatalogUnit._();

  factory CatalogUnit([void updates(CatalogUnitBuilder b)]) = _$CatalogUnit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogUnitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogUnit> get serializer => _$CatalogUnitSerializer();
}

class _$CatalogUnitSerializer implements PrimitiveSerializer<CatalogUnit> {
  @override
  final Iterable<Type> types = const [CatalogUnit, _$CatalogUnit];

  @override
  final String wireName = r'CatalogUnit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogUnit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'dimension';
    yield serializers.serialize(
      object.dimension,
      specifiedType: const FullType(String),
    );
    yield r'precision';
    yield serializers.serialize(
      object.precision,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogUnit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogUnitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'dimension':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dimension = valueDes;
          break;
        case r'precision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.precision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogUnit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogUnitBuilder();
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


