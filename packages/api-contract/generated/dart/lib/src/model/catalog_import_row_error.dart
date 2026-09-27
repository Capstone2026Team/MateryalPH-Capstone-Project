//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_import_row_error.g.dart';

/// CatalogImportRowError
///
/// Properties:
/// * [rowNumber] - Spreadsheet row number including the header row.
/// * [vendorSku]
/// * [variantSku]
/// * [errors]
@BuiltValue()
abstract class CatalogImportRowError implements Built<CatalogImportRowError, CatalogImportRowErrorBuilder> {
  /// Spreadsheet row number including the header row.
  @BuiltValueField(wireName: r'row_number')
  int get rowNumber;

  @BuiltValueField(wireName: r'vendor_sku')
  String? get vendorSku;

  @BuiltValueField(wireName: r'variant_sku')
  String? get variantSku;

  @BuiltValueField(wireName: r'errors')
  BuiltMap<String, BuiltList<String>> get errors;

  CatalogImportRowError._();

  factory CatalogImportRowError([void updates(CatalogImportRowErrorBuilder b)]) = _$CatalogImportRowError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogImportRowErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogImportRowError> get serializer => _$CatalogImportRowErrorSerializer();
}

class _$CatalogImportRowErrorSerializer implements PrimitiveSerializer<CatalogImportRowError> {
  @override
  final Iterable<Type> types = const [CatalogImportRowError, _$CatalogImportRowError];

  @override
  final String wireName = r'CatalogImportRowError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogImportRowError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'row_number';
    yield serializers.serialize(
      object.rowNumber,
      specifiedType: const FullType(int),
    );
    if (object.vendorSku != null) {
      yield r'vendor_sku';
      yield serializers.serialize(
        object.vendorSku,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.variantSku != null) {
      yield r'variant_sku';
      yield serializers.serialize(
        object.variantSku,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(BuiltList, [FullType(String)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogImportRowError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogImportRowErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'row_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowNumber = valueDes;
          break;
        case r'vendor_sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorSku = valueDes;
          break;
        case r'variant_sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantSku = valueDes;
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(BuiltList, [FullType(String)])]),
          ) as BuiltMap<String, BuiltList<String>>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogImportRowError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogImportRowErrorBuilder();
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


