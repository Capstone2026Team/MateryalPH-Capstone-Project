//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_import_template.g.dart';

/// CatalogImportTemplate
///
/// Properties:
/// * [templateVersion]
/// * [columns]
/// * [requiredColumns]
/// * [maxRows]
@BuiltValue()
abstract class CatalogImportTemplate implements Built<CatalogImportTemplate, CatalogImportTemplateBuilder> {
  @BuiltValueField(wireName: r'template_version')
  String get templateVersion;

  @BuiltValueField(wireName: r'columns')
  BuiltList<String> get columns;

  @BuiltValueField(wireName: r'required_columns')
  BuiltList<String> get requiredColumns;

  @BuiltValueField(wireName: r'max_rows')
  int get maxRows;

  CatalogImportTemplate._();

  factory CatalogImportTemplate([void updates(CatalogImportTemplateBuilder b)]) = _$CatalogImportTemplate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogImportTemplateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogImportTemplate> get serializer => _$CatalogImportTemplateSerializer();
}

class _$CatalogImportTemplateSerializer implements PrimitiveSerializer<CatalogImportTemplate> {
  @override
  final Iterable<Type> types = const [CatalogImportTemplate, _$CatalogImportTemplate];

  @override
  final String wireName = r'CatalogImportTemplate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogImportTemplate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'template_version';
    yield serializers.serialize(
      object.templateVersion,
      specifiedType: const FullType(String),
    );
    yield r'columns';
    yield serializers.serialize(
      object.columns,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'required_columns';
    yield serializers.serialize(
      object.requiredColumns,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'max_rows';
    yield serializers.serialize(
      object.maxRows,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogImportTemplate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogImportTemplateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'template_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.templateVersion = valueDes;
          break;
        case r'columns':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.columns.replace(valueDes);
          break;
        case r'required_columns':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.requiredColumns.replace(valueDes);
          break;
        case r'max_rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxRows = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogImportTemplate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogImportTemplateBuilder();
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


