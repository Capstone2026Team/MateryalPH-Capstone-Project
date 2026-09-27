//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/catalog_import_row_error.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_import_job.g.dart';

/// CatalogImportJob
///
/// Properties:
/// * [id]
/// * [status]
/// * [templateVersion]
/// * [totalRows]
/// * [validRows]
/// * [errorRows]
/// * [appliedRows]
/// * [appliedAt]
/// * [createdAt]
/// * [rowErrors]
/// * [rowErrorsMeta]
@BuiltValue()
abstract class CatalogImportJob implements Built<CatalogImportJob, CatalogImportJobBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  CatalogImportJobStatusEnum get status;
  // enum statusEnum {  VALIDATED,  HAS_ERRORS,  APPLIED,  APPLIED_WITH_REJECTIONS,  FAILED,  };

  @BuiltValueField(wireName: r'template_version')
  String get templateVersion;

  @BuiltValueField(wireName: r'total_rows')
  int get totalRows;

  @BuiltValueField(wireName: r'valid_rows')
  int get validRows;

  @BuiltValueField(wireName: r'error_rows')
  int get errorRows;

  @BuiltValueField(wireName: r'applied_rows')
  int get appliedRows;

  @BuiltValueField(wireName: r'applied_at')
  String? get appliedAt;

  @BuiltValueField(wireName: r'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: r'row_errors')
  BuiltList<CatalogImportRowError> get rowErrors;

  @BuiltValueField(wireName: r'row_errors_meta')
  BuiltMap<String, JsonObject?> get rowErrorsMeta;

  CatalogImportJob._();

  factory CatalogImportJob([void updates(CatalogImportJobBuilder b)]) = _$CatalogImportJob;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogImportJobBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogImportJob> get serializer => _$CatalogImportJobSerializer();
}

class _$CatalogImportJobSerializer implements PrimitiveSerializer<CatalogImportJob> {
  @override
  final Iterable<Type> types = const [CatalogImportJob, _$CatalogImportJob];

  @override
  final String wireName = r'CatalogImportJob';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogImportJob object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CatalogImportJobStatusEnum),
    );
    yield r'template_version';
    yield serializers.serialize(
      object.templateVersion,
      specifiedType: const FullType(String),
    );
    yield r'total_rows';
    yield serializers.serialize(
      object.totalRows,
      specifiedType: const FullType(int),
    );
    yield r'valid_rows';
    yield serializers.serialize(
      object.validRows,
      specifiedType: const FullType(int),
    );
    yield r'error_rows';
    yield serializers.serialize(
      object.errorRows,
      specifiedType: const FullType(int),
    );
    yield r'applied_rows';
    yield serializers.serialize(
      object.appliedRows,
      specifiedType: const FullType(int),
    );
    if (object.appliedAt != null) {
      yield r'applied_at';
      yield serializers.serialize(
        object.appliedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'row_errors';
    yield serializers.serialize(
      object.rowErrors,
      specifiedType: const FullType(BuiltList, [FullType(CatalogImportRowError)]),
    );
    yield r'row_errors_meta';
    yield serializers.serialize(
      object.rowErrorsMeta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogImportJob object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogImportJobBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogImportJobStatusEnum),
          ) as CatalogImportJobStatusEnum;
          result.status = valueDes;
          break;
        case r'template_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.templateVersion = valueDes;
          break;
        case r'total_rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalRows = valueDes;
          break;
        case r'valid_rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.validRows = valueDes;
          break;
        case r'error_rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.errorRows = valueDes;
          break;
        case r'applied_rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.appliedRows = valueDes;
          break;
        case r'applied_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.appliedAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'row_errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogImportRowError)]),
          ) as BuiltList<CatalogImportRowError>;
          result.rowErrors.replace(valueDes);
          break;
        case r'row_errors_meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.rowErrorsMeta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogImportJob deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogImportJobBuilder();
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


class CatalogImportJobStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALIDATED')
  static const CatalogImportJobStatusEnum VALIDATED = _$catalogImportJobStatusEnum_VALIDATED;
  @BuiltValueEnumConst(wireName: r'HAS_ERRORS')
  static const CatalogImportJobStatusEnum HAS_ERRORS = _$catalogImportJobStatusEnum_HAS_ERRORS;
  @BuiltValueEnumConst(wireName: r'APPLIED')
  static const CatalogImportJobStatusEnum APPLIED = _$catalogImportJobStatusEnum_APPLIED;
  @BuiltValueEnumConst(wireName: r'APPLIED_WITH_REJECTIONS')
  static const CatalogImportJobStatusEnum APPLIED_WITH_REJECTIONS = _$catalogImportJobStatusEnum_APPLIED_WITH_REJECTIONS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const CatalogImportJobStatusEnum FAILED = _$catalogImportJobStatusEnum_FAILED;

  static Serializer<CatalogImportJobStatusEnum> get serializer => _$catalogImportJobStatusEnumSerializer;

  const CatalogImportJobStatusEnum._(String name): super(name);

  static BuiltSet<CatalogImportJobStatusEnum> get values => _$catalogImportJobStatusEnumValues;
  static CatalogImportJobStatusEnum valueOf(String name) => _$catalogImportJobStatusEnumValueOf(name);
}

