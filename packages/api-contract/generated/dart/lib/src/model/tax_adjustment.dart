//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_adjustment.g.dart';

/// TaxAdjustment
///
/// Properties:
/// * [id]
/// * [kind]
/// * [state]
/// * [environment]
/// * [openedBy]
/// * [orderReference]
/// * [vendorName]
/// * [originalRecordType]
/// * [originalRecordId]
/// * [periodStart]
/// * [periodEnd]
/// * [amountCentavos]
/// * [beforeValues]
/// * [afterValues]
/// * [reason]
/// * [preparer]
/// * [reviewer]
/// * [reviewedAt]
/// * [postedAt]
/// * [createdAt]
/// * [allowedActions]
/// * [separationNote]
@BuiltValue()
abstract class TaxAdjustment implements Built<TaxAdjustment, TaxAdjustmentBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'state')
  TaxAdjustmentStateEnum get state;
  // enum stateEnum {  ADJUSTMENT_REQUIRED,  UNDER_REVIEW,  APPROVED,  POSTED,  REJECTED,  };

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'opened_by')
  TaxAdjustmentOpenedByEnum get openedBy;
  // enum openedByEnum {  USER,  SYSTEM,  };

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'vendor_name')
  String? get vendorName;

  @BuiltValueField(wireName: r'original_record_type')
  String get originalRecordType;

  @BuiltValueField(wireName: r'original_record_id')
  String get originalRecordId;

  @BuiltValueField(wireName: r'period_start')
  Date get periodStart;

  @BuiltValueField(wireName: r'period_end')
  Date get periodEnd;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'before_values')
  BuiltMap<String, JsonObject?> get beforeValues;

  @BuiltValueField(wireName: r'after_values')
  BuiltMap<String, JsonObject?> get afterValues;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'preparer')
  String? get preparer;

  @BuiltValueField(wireName: r'reviewer')
  String? get reviewer;

  @BuiltValueField(wireName: r'reviewed_at')
  DateTime? get reviewedAt;

  @BuiltValueField(wireName: r'posted_at')
  DateTime? get postedAt;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'allowed_actions')
  BuiltList<TaxAdjustmentAllowedActionsEnum> get allowedActions;
  // enum allowedActionsEnum {  PREPARE,  APPROVE,  REJECT,  POST,  };

  @BuiltValueField(wireName: r'separation_note')
  String? get separationNote;

  TaxAdjustment._();

  factory TaxAdjustment([void updates(TaxAdjustmentBuilder b)]) = _$TaxAdjustment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxAdjustmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxAdjustment> get serializer => _$TaxAdjustmentSerializer();
}

class _$TaxAdjustmentSerializer implements PrimitiveSerializer<TaxAdjustment> {
  @override
  final Iterable<Type> types = const [TaxAdjustment, _$TaxAdjustment];

  @override
  final String wireName = r'TaxAdjustment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxAdjustment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(TaxAdjustmentStateEnum),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'opened_by';
    yield serializers.serialize(
      object.openedBy,
      specifiedType: const FullType(TaxAdjustmentOpenedByEnum),
    );
    if (object.orderReference != null) {
      yield r'order_reference';
      yield serializers.serialize(
        object.orderReference,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.vendorName != null) {
      yield r'vendor_name';
      yield serializers.serialize(
        object.vendorName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'original_record_type';
    yield serializers.serialize(
      object.originalRecordType,
      specifiedType: const FullType(String),
    );
    yield r'original_record_id';
    yield serializers.serialize(
      object.originalRecordId,
      specifiedType: const FullType(String),
    );
    yield r'period_start';
    yield serializers.serialize(
      object.periodStart,
      specifiedType: const FullType(Date),
    );
    yield r'period_end';
    yield serializers.serialize(
      object.periodEnd,
      specifiedType: const FullType(Date),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'before_values';
    yield serializers.serialize(
      object.beforeValues,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'after_values';
    yield serializers.serialize(
      object.afterValues,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.preparer != null) {
      yield r'preparer';
      yield serializers.serialize(
        object.preparer,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reviewer != null) {
      yield r'reviewer';
      yield serializers.serialize(
        object.reviewer,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reviewedAt != null) {
      yield r'reviewed_at';
      yield serializers.serialize(
        object.reviewedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.postedAt != null) {
      yield r'posted_at';
      yield serializers.serialize(
        object.postedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'allowed_actions';
    yield serializers.serialize(
      object.allowedActions,
      specifiedType: const FullType(BuiltList, [FullType(TaxAdjustmentAllowedActionsEnum)]),
    );
    if (object.separationNote != null) {
      yield r'separation_note';
      yield serializers.serialize(
        object.separationNote,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxAdjustment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxAdjustmentBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.kind = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxAdjustmentStateEnum),
          ) as TaxAdjustmentStateEnum;
          result.state = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'opened_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxAdjustmentOpenedByEnum),
          ) as TaxAdjustmentOpenedByEnum;
          result.openedBy = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderReference = valueDes;
          break;
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorName = valueDes;
          break;
        case r'original_record_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalRecordType = valueDes;
          break;
        case r'original_record_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalRecordId = valueDes;
          break;
        case r'period_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.periodStart = valueDes;
          break;
        case r'period_end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.periodEnd = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'before_values':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.beforeValues.replace(valueDes);
          break;
        case r'after_values':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.afterValues.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'preparer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.preparer = valueDes;
          break;
        case r'reviewer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewer = valueDes;
          break;
        case r'reviewed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        case r'posted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.postedAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'allowed_actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TaxAdjustmentAllowedActionsEnum)]),
          ) as BuiltList<TaxAdjustmentAllowedActionsEnum>;
          result.allowedActions.replace(valueDes);
          break;
        case r'separation_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.separationNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxAdjustment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxAdjustmentBuilder();
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


class TaxAdjustmentStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADJUSTMENT_REQUIRED')
  static const TaxAdjustmentStateEnum ADJUSTMENT_REQUIRED = _$taxAdjustmentStateEnum_ADJUSTMENT_REQUIRED;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const TaxAdjustmentStateEnum UNDER_REVIEW = _$taxAdjustmentStateEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const TaxAdjustmentStateEnum APPROVED = _$taxAdjustmentStateEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'POSTED')
  static const TaxAdjustmentStateEnum POSTED = _$taxAdjustmentStateEnum_POSTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const TaxAdjustmentStateEnum REJECTED = _$taxAdjustmentStateEnum_REJECTED;

  static Serializer<TaxAdjustmentStateEnum> get serializer => _$taxAdjustmentStateEnumSerializer;

  const TaxAdjustmentStateEnum._(String name): super(name);

  static BuiltSet<TaxAdjustmentStateEnum> get values => _$taxAdjustmentStateEnumValues;
  static TaxAdjustmentStateEnum valueOf(String name) => _$taxAdjustmentStateEnumValueOf(name);
}

class TaxAdjustmentOpenedByEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'USER')
  static const TaxAdjustmentOpenedByEnum USER = _$taxAdjustmentOpenedByEnum_USER;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const TaxAdjustmentOpenedByEnum SYSTEM = _$taxAdjustmentOpenedByEnum_SYSTEM;

  static Serializer<TaxAdjustmentOpenedByEnum> get serializer => _$taxAdjustmentOpenedByEnumSerializer;

  const TaxAdjustmentOpenedByEnum._(String name): super(name);

  static BuiltSet<TaxAdjustmentOpenedByEnum> get values => _$taxAdjustmentOpenedByEnumValues;
  static TaxAdjustmentOpenedByEnum valueOf(String name) => _$taxAdjustmentOpenedByEnumValueOf(name);
}

class TaxAdjustmentAllowedActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PREPARE')
  static const TaxAdjustmentAllowedActionsEnum PREPARE = _$taxAdjustmentAllowedActionsEnum_PREPARE;
  @BuiltValueEnumConst(wireName: r'APPROVE')
  static const TaxAdjustmentAllowedActionsEnum APPROVE = _$taxAdjustmentAllowedActionsEnum_APPROVE;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const TaxAdjustmentAllowedActionsEnum REJECT = _$taxAdjustmentAllowedActionsEnum_REJECT;
  @BuiltValueEnumConst(wireName: r'POST')
  static const TaxAdjustmentAllowedActionsEnum POST = _$taxAdjustmentAllowedActionsEnum_POST;

  static Serializer<TaxAdjustmentAllowedActionsEnum> get serializer => _$taxAdjustmentAllowedActionsEnumSerializer;

  const TaxAdjustmentAllowedActionsEnum._(String name): super(name);

  static BuiltSet<TaxAdjustmentAllowedActionsEnum> get values => _$taxAdjustmentAllowedActionsEnumValues;
  static TaxAdjustmentAllowedActionsEnum valueOf(String name) => _$taxAdjustmentAllowedActionsEnumValueOf(name);
}

