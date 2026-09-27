//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/catalog_variant_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_variants_save.g.dart';

/// CatalogVariantsSave
///
/// Properties:
/// * [lockVersion]
/// * [variants]
@BuiltValue()
abstract class CatalogVariantsSave implements Built<CatalogVariantsSave, CatalogVariantsSaveBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'variants')
  BuiltList<CatalogVariantInput> get variants;

  CatalogVariantsSave._();

  factory CatalogVariantsSave([void updates(CatalogVariantsSaveBuilder b)]) = _$CatalogVariantsSave;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogVariantsSaveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogVariantsSave> get serializer => _$CatalogVariantsSaveSerializer();
}

class _$CatalogVariantsSaveSerializer implements PrimitiveSerializer<CatalogVariantsSave> {
  @override
  final Iterable<Type> types = const [CatalogVariantsSave, _$CatalogVariantsSave];

  @override
  final String wireName = r'CatalogVariantsSave';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogVariantsSave object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(BuiltList, [FullType(CatalogVariantInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogVariantsSave object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogVariantsSaveBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogVariantInput)]),
          ) as BuiltList<CatalogVariantInput>;
          result.variants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogVariantsSave deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogVariantsSaveBuilder();
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


