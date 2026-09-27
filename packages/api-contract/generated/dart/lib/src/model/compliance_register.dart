//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_register.g.dart';

/// ComplianceRegister
///
/// Properties:
/// * [id]
/// * [registerKind]
/// * [sourceReference]
/// * [snapshotDate]
/// * [status]
/// * [rowCount]
/// * [rejectedRowCount]
/// * [activatedAt]
/// * [supersededAt]
/// * [createdAt]
/// * [columnMapping]
/// * [rejectedRows]
@BuiltValue()
abstract class ComplianceRegister implements Built<ComplianceRegister, ComplianceRegisterBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'register_kind')
  ComplianceRegisterRegisterKindEnum get registerKind;
  // enum registerKindEnum {  PS_LICENSE,  ICC_CERTIFICATE,  };

  @BuiltValueField(wireName: r'source_reference')
  String get sourceReference;

  @BuiltValueField(wireName: r'snapshot_date')
  Date get snapshotDate;

  @BuiltValueField(wireName: r'status')
  ComplianceRegisterStatusEnum get status;
  // enum statusEnum {  DRAFT,  ACTIVE,  SUPERSEDED,  };

  @BuiltValueField(wireName: r'row_count')
  int get rowCount;

  @BuiltValueField(wireName: r'rejected_row_count')
  int get rejectedRowCount;

  @BuiltValueField(wireName: r'activated_at')
  String? get activatedAt;

  @BuiltValueField(wireName: r'superseded_at')
  String? get supersededAt;

  @BuiltValueField(wireName: r'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: r'column_mapping')
  BuiltMap<String, JsonObject?>? get columnMapping;

  @BuiltValueField(wireName: r'rejected_rows')
  BuiltList<BuiltMap<String, JsonObject?>>? get rejectedRows;

  ComplianceRegister._();

  factory ComplianceRegister([void updates(ComplianceRegisterBuilder b)]) = _$ComplianceRegister;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceRegisterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceRegister> get serializer => _$ComplianceRegisterSerializer();
}

class _$ComplianceRegisterSerializer implements PrimitiveSerializer<ComplianceRegister> {
  @override
  final Iterable<Type> types = const [ComplianceRegister, _$ComplianceRegister];

  @override
  final String wireName = r'ComplianceRegister';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceRegister object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'register_kind';
    yield serializers.serialize(
      object.registerKind,
      specifiedType: const FullType(ComplianceRegisterRegisterKindEnum),
    );
    yield r'source_reference';
    yield serializers.serialize(
      object.sourceReference,
      specifiedType: const FullType(String),
    );
    yield r'snapshot_date';
    yield serializers.serialize(
      object.snapshotDate,
      specifiedType: const FullType(Date),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ComplianceRegisterStatusEnum),
    );
    yield r'row_count';
    yield serializers.serialize(
      object.rowCount,
      specifiedType: const FullType(int),
    );
    yield r'rejected_row_count';
    yield serializers.serialize(
      object.rejectedRowCount,
      specifiedType: const FullType(int),
    );
    if (object.activatedAt != null) {
      yield r'activated_at';
      yield serializers.serialize(
        object.activatedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.supersededAt != null) {
      yield r'superseded_at';
      yield serializers.serialize(
        object.supersededAt,
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
    if (object.columnMapping != null) {
      yield r'column_mapping';
      yield serializers.serialize(
        object.columnMapping,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.rejectedRows != null) {
      yield r'rejected_rows';
      yield serializers.serialize(
        object.rejectedRows,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceRegister object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceRegisterBuilder result,
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
        case r'register_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceRegisterRegisterKindEnum),
          ) as ComplianceRegisterRegisterKindEnum;
          result.registerKind = valueDes;
          break;
        case r'source_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceReference = valueDes;
          break;
        case r'snapshot_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.snapshotDate = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceRegisterStatusEnum),
          ) as ComplianceRegisterStatusEnum;
          result.status = valueDes;
          break;
        case r'row_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowCount = valueDes;
          break;
        case r'rejected_row_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rejectedRowCount = valueDes;
          break;
        case r'activated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.activatedAt = valueDes;
          break;
        case r'superseded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supersededAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'column_mapping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.columnMapping.replace(valueDes);
          break;
        case r'rejected_rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.rejectedRows.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceRegister deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceRegisterBuilder();
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


class ComplianceRegisterRegisterKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PS_LICENSE')
  static const ComplianceRegisterRegisterKindEnum PS_LICENSE = _$complianceRegisterRegisterKindEnum_PS_LICENSE;
  @BuiltValueEnumConst(wireName: r'ICC_CERTIFICATE')
  static const ComplianceRegisterRegisterKindEnum ICC_CERTIFICATE = _$complianceRegisterRegisterKindEnum_ICC_CERTIFICATE;

  static Serializer<ComplianceRegisterRegisterKindEnum> get serializer => _$complianceRegisterRegisterKindEnumSerializer;

  const ComplianceRegisterRegisterKindEnum._(String name): super(name);

  static BuiltSet<ComplianceRegisterRegisterKindEnum> get values => _$complianceRegisterRegisterKindEnumValues;
  static ComplianceRegisterRegisterKindEnum valueOf(String name) => _$complianceRegisterRegisterKindEnumValueOf(name);
}

class ComplianceRegisterStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const ComplianceRegisterStatusEnum DRAFT = _$complianceRegisterStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ComplianceRegisterStatusEnum ACTIVE = _$complianceRegisterStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUPERSEDED')
  static const ComplianceRegisterStatusEnum SUPERSEDED = _$complianceRegisterStatusEnum_SUPERSEDED;

  static Serializer<ComplianceRegisterStatusEnum> get serializer => _$complianceRegisterStatusEnumSerializer;

  const ComplianceRegisterStatusEnum._(String name): super(name);

  static BuiltSet<ComplianceRegisterStatusEnum> get values => _$complianceRegisterStatusEnumValues;
  static ComplianceRegisterStatusEnum valueOf(String name) => _$complianceRegisterStatusEnumValueOf(name);
}

