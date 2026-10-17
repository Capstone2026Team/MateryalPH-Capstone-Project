//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'document_export_input.g.dart';

/// DocumentExportInput
///
/// Properties:
/// * [type]
/// * [format]
/// * [resourceId]
/// * [purpose]
/// * [filters]
@BuiltValue()
abstract class DocumentExportInput implements Built<DocumentExportInput, DocumentExportInputBuilder> {
  @BuiltValueField(wireName: r'type')
  DocumentExportInputTypeEnum get type;
  // enum typeEnum {  PURCHASE_ORDER,  PAYMENT_CONFIRMATION,  PROJECT_SUMMARY,  BUDGET_REPORT,  OPERATIONAL_ORDER,  FEE_STATEMENT,  MATERIALS_ANALYTICS,  TAX_PACKAGE,  AUDIT_LOG,  GEO_ANALYTICS,  TRANSACTION_HISTORY,  EARNINGS,  };

  @BuiltValueField(wireName: r'format')
  DocumentExportInputFormatEnum get format;
  // enum formatEnum {  PDF,  CSV,  };

  @BuiltValueField(wireName: r'resource_id')
  String? get resourceId;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  @BuiltValueField(wireName: r'filters')
  BuiltMap<String, JsonObject?>? get filters;

  DocumentExportInput._();

  factory DocumentExportInput([void updates(DocumentExportInputBuilder b)]) = _$DocumentExportInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentExportInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentExportInput> get serializer => _$DocumentExportInputSerializer();
}

class _$DocumentExportInputSerializer implements PrimitiveSerializer<DocumentExportInput> {
  @override
  final Iterable<Type> types = const [DocumentExportInput, _$DocumentExportInput];

  @override
  final String wireName = r'DocumentExportInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentExportInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(DocumentExportInputTypeEnum),
    );
    yield r'format';
    yield serializers.serialize(
      object.format,
      specifiedType: const FullType(DocumentExportInputFormatEnum),
    );
    if (object.resourceId != null) {
      yield r'resource_id';
      yield serializers.serialize(
        object.resourceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
    if (object.filters != null) {
      yield r'filters';
      yield serializers.serialize(
        object.filters,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DocumentExportInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DocumentExportInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DocumentExportInputTypeEnum),
          ) as DocumentExportInputTypeEnum;
          result.type = valueDes;
          break;
        case r'format':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DocumentExportInputFormatEnum),
          ) as DocumentExportInputFormatEnum;
          result.format = valueDes;
          break;
        case r'resource_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.resourceId = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        case r'filters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.filters.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DocumentExportInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentExportInputBuilder();
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


class DocumentExportInputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PURCHASE_ORDER')
  static const DocumentExportInputTypeEnum PURCHASE_ORDER = _$documentExportInputTypeEnum_PURCHASE_ORDER;
  @BuiltValueEnumConst(wireName: r'PAYMENT_CONFIRMATION')
  static const DocumentExportInputTypeEnum PAYMENT_CONFIRMATION = _$documentExportInputTypeEnum_PAYMENT_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PROJECT_SUMMARY')
  static const DocumentExportInputTypeEnum PROJECT_SUMMARY = _$documentExportInputTypeEnum_PROJECT_SUMMARY;
  @BuiltValueEnumConst(wireName: r'BUDGET_REPORT')
  static const DocumentExportInputTypeEnum BUDGET_REPORT = _$documentExportInputTypeEnum_BUDGET_REPORT;
  @BuiltValueEnumConst(wireName: r'OPERATIONAL_ORDER')
  static const DocumentExportInputTypeEnum OPERATIONAL_ORDER = _$documentExportInputTypeEnum_OPERATIONAL_ORDER;
  @BuiltValueEnumConst(wireName: r'FEE_STATEMENT')
  static const DocumentExportInputTypeEnum FEE_STATEMENT = _$documentExportInputTypeEnum_FEE_STATEMENT;
  @BuiltValueEnumConst(wireName: r'MATERIALS_ANALYTICS')
  static const DocumentExportInputTypeEnum MATERIALS_ANALYTICS = _$documentExportInputTypeEnum_MATERIALS_ANALYTICS;
  @BuiltValueEnumConst(wireName: r'TAX_PACKAGE')
  static const DocumentExportInputTypeEnum TAX_PACKAGE = _$documentExportInputTypeEnum_TAX_PACKAGE;
  @BuiltValueEnumConst(wireName: r'AUDIT_LOG')
  static const DocumentExportInputTypeEnum AUDIT_LOG = _$documentExportInputTypeEnum_AUDIT_LOG;
  @BuiltValueEnumConst(wireName: r'GEO_ANALYTICS')
  static const DocumentExportInputTypeEnum GEO_ANALYTICS = _$documentExportInputTypeEnum_GEO_ANALYTICS;
  @BuiltValueEnumConst(wireName: r'TRANSACTION_HISTORY')
  static const DocumentExportInputTypeEnum TRANSACTION_HISTORY = _$documentExportInputTypeEnum_TRANSACTION_HISTORY;
  @BuiltValueEnumConst(wireName: r'EARNINGS')
  static const DocumentExportInputTypeEnum EARNINGS = _$documentExportInputTypeEnum_EARNINGS;

  static Serializer<DocumentExportInputTypeEnum> get serializer => _$documentExportInputTypeEnumSerializer;

  const DocumentExportInputTypeEnum._(String name): super(name);

  static BuiltSet<DocumentExportInputTypeEnum> get values => _$documentExportInputTypeEnumValues;
  static DocumentExportInputTypeEnum valueOf(String name) => _$documentExportInputTypeEnumValueOf(name);
}

class DocumentExportInputFormatEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PDF')
  static const DocumentExportInputFormatEnum PDF = _$documentExportInputFormatEnum_PDF;
  @BuiltValueEnumConst(wireName: r'CSV')
  static const DocumentExportInputFormatEnum CSV = _$documentExportInputFormatEnum_CSV;

  static Serializer<DocumentExportInputFormatEnum> get serializer => _$documentExportInputFormatEnumSerializer;

  const DocumentExportInputFormatEnum._(String name): super(name);

  static BuiltSet<DocumentExportInputFormatEnum> get values => _$documentExportInputFormatEnumValues;
  static DocumentExportInputFormatEnum valueOf(String name) => _$documentExportInputFormatEnumValueOf(name);
}

