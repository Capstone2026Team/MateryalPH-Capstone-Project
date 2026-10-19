//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_fulfillment_line.g.dart';

/// ProjectFulfillmentLine
///
/// Properties:
/// * [lineId]
/// * [name]
/// * [unitCode]
/// * [requiredQuantity]
/// * [vendorQuantity] - Quantity this Vendor supplies.
/// * [separateQuantity] - Quantity covered by separate purchases that satisfy the requirement.
/// * [substituteQuantity] - Quantity bought as a similar product; it does not close the requirement.
/// * [remainingQuantity] - Quantity still to be sourced.
/// * [status]
/// * [missingReason]
@BuiltValue()
abstract class ProjectFulfillmentLine implements Built<ProjectFulfillmentLine, ProjectFulfillmentLineBuilder> {
  @BuiltValueField(wireName: r'line_id')
  String get lineId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'required_quantity')
  String get requiredQuantity;

  /// Quantity this Vendor supplies.
  @BuiltValueField(wireName: r'vendor_quantity')
  String get vendorQuantity;

  /// Quantity covered by separate purchases that satisfy the requirement.
  @BuiltValueField(wireName: r'separate_quantity')
  String get separateQuantity;

  /// Quantity bought as a similar product; it does not close the requirement.
  @BuiltValueField(wireName: r'substitute_quantity')
  String get substituteQuantity;

  /// Quantity still to be sourced.
  @BuiltValueField(wireName: r'remaining_quantity')
  String get remainingQuantity;

  @BuiltValueField(wireName: r'status')
  ProjectFulfillmentLineStatusEnum get status;
  // enum statusEnum {  FULFILLED,  PARTIAL,  UNFULFILLED,  };

  @BuiltValueField(wireName: r'missing_reason')
  String? get missingReason;

  ProjectFulfillmentLine._();

  factory ProjectFulfillmentLine([void updates(ProjectFulfillmentLineBuilder b)]) = _$ProjectFulfillmentLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectFulfillmentLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectFulfillmentLine> get serializer => _$ProjectFulfillmentLineSerializer();
}

class _$ProjectFulfillmentLineSerializer implements PrimitiveSerializer<ProjectFulfillmentLine> {
  @override
  final Iterable<Type> types = const [ProjectFulfillmentLine, _$ProjectFulfillmentLine];

  @override
  final String wireName = r'ProjectFulfillmentLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectFulfillmentLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'line_id';
    yield serializers.serialize(
      object.lineId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'required_quantity';
    yield serializers.serialize(
      object.requiredQuantity,
      specifiedType: const FullType(String),
    );
    yield r'vendor_quantity';
    yield serializers.serialize(
      object.vendorQuantity,
      specifiedType: const FullType(String),
    );
    yield r'separate_quantity';
    yield serializers.serialize(
      object.separateQuantity,
      specifiedType: const FullType(String),
    );
    yield r'substitute_quantity';
    yield serializers.serialize(
      object.substituteQuantity,
      specifiedType: const FullType(String),
    );
    yield r'remaining_quantity';
    yield serializers.serialize(
      object.remainingQuantity,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProjectFulfillmentLineStatusEnum),
    );
    if (object.missingReason != null) {
      yield r'missing_reason';
      yield serializers.serialize(
        object.missingReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectFulfillmentLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectFulfillmentLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lineId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'required_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requiredQuantity = valueDes;
          break;
        case r'vendor_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorQuantity = valueDes;
          break;
        case r'separate_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.separateQuantity = valueDes;
          break;
        case r'substitute_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.substituteQuantity = valueDes;
          break;
        case r'remaining_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.remainingQuantity = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectFulfillmentLineStatusEnum),
          ) as ProjectFulfillmentLineStatusEnum;
          result.status = valueDes;
          break;
        case r'missing_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.missingReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectFulfillmentLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectFulfillmentLineBuilder();
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


class ProjectFulfillmentLineStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FULFILLED')
  static const ProjectFulfillmentLineStatusEnum FULFILLED = _$projectFulfillmentLineStatusEnum_FULFILLED;
  @BuiltValueEnumConst(wireName: r'PARTIAL')
  static const ProjectFulfillmentLineStatusEnum PARTIAL = _$projectFulfillmentLineStatusEnum_PARTIAL;
  @BuiltValueEnumConst(wireName: r'UNFULFILLED')
  static const ProjectFulfillmentLineStatusEnum UNFULFILLED = _$projectFulfillmentLineStatusEnum_UNFULFILLED;

  static Serializer<ProjectFulfillmentLineStatusEnum> get serializer => _$projectFulfillmentLineStatusEnumSerializer;

  const ProjectFulfillmentLineStatusEnum._(String name): super(name);

  static BuiltSet<ProjectFulfillmentLineStatusEnum> get values => _$projectFulfillmentLineStatusEnumValues;
  static ProjectFulfillmentLineStatusEnum valueOf(String name) => _$projectFulfillmentLineStatusEnumValueOf(name);
}

