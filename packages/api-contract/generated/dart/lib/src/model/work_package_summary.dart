//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_summary.g.dart';

/// WorkPackageSummary
///
/// Properties:
/// * [id]
/// * [projectId]
/// * [name]
/// * [status]
/// * [budgetCentavos]
/// * [lockVersion]
/// * [currentVersionId]
/// * [selectedVendorId]
/// * [orderId]
@BuiltValue()
abstract class WorkPackageSummary implements Built<WorkPackageSummary, WorkPackageSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'project_id')
  String get projectId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  WorkPackageSummaryStatusEnum get status;
  // enum statusEnum {  DRAFT,  ACTIVE,  QUOTATION_INQUIRY,  VENDOR_SELECTED,  AWAITING_PAYMENT,  IN_PROGRESS,  COMPLETED,  CANCELLED,  };

  @BuiltValueField(wireName: r'budget_centavos')
  int get budgetCentavos;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'current_version_id')
  String? get currentVersionId;

  @BuiltValueField(wireName: r'selected_vendor_id')
  String? get selectedVendorId;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  WorkPackageSummary._();

  factory WorkPackageSummary([void updates(WorkPackageSummaryBuilder b)]) = _$WorkPackageSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageSummary> get serializer => _$WorkPackageSummarySerializer();
}

class _$WorkPackageSummarySerializer implements PrimitiveSerializer<WorkPackageSummary> {
  @override
  final Iterable<Type> types = const [WorkPackageSummary, _$WorkPackageSummary];

  @override
  final String wireName = r'WorkPackageSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'project_id';
    yield serializers.serialize(
      object.projectId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WorkPackageSummaryStatusEnum),
    );
    yield r'budget_centavos';
    yield serializers.serialize(
      object.budgetCentavos,
      specifiedType: const FullType(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.currentVersionId != null) {
      yield r'current_version_id';
      yield serializers.serialize(
        object.currentVersionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.selectedVendorId != null) {
      yield r'selected_vendor_id';
      yield serializers.serialize(
        object.selectedVendorId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageSummaryBuilder result,
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
        case r'project_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.projectId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageSummaryStatusEnum),
          ) as WorkPackageSummaryStatusEnum;
          result.status = valueDes;
          break;
        case r'budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.budgetCentavos = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'current_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentVersionId = valueDes;
          break;
        case r'selected_vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.selectedVendorId = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageSummaryBuilder();
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


class WorkPackageSummaryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const WorkPackageSummaryStatusEnum DRAFT = _$workPackageSummaryStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const WorkPackageSummaryStatusEnum ACTIVE = _$workPackageSummaryStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'QUOTATION_INQUIRY')
  static const WorkPackageSummaryStatusEnum QUOTATION_INQUIRY = _$workPackageSummaryStatusEnum_QUOTATION_INQUIRY;
  @BuiltValueEnumConst(wireName: r'VENDOR_SELECTED')
  static const WorkPackageSummaryStatusEnum VENDOR_SELECTED = _$workPackageSummaryStatusEnum_VENDOR_SELECTED;
  @BuiltValueEnumConst(wireName: r'AWAITING_PAYMENT')
  static const WorkPackageSummaryStatusEnum AWAITING_PAYMENT = _$workPackageSummaryStatusEnum_AWAITING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const WorkPackageSummaryStatusEnum IN_PROGRESS = _$workPackageSummaryStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const WorkPackageSummaryStatusEnum COMPLETED = _$workPackageSummaryStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const WorkPackageSummaryStatusEnum CANCELLED = _$workPackageSummaryStatusEnum_CANCELLED;

  static Serializer<WorkPackageSummaryStatusEnum> get serializer => _$workPackageSummaryStatusEnumSerializer;

  const WorkPackageSummaryStatusEnum._(String name): super(name);

  static BuiltSet<WorkPackageSummaryStatusEnum> get values => _$workPackageSummaryStatusEnumValues;
  static WorkPackageSummaryStatusEnum valueOf(String name) => _$workPackageSummaryStatusEnumValueOf(name);
}

