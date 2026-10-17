//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_budget_estimate_line.g.dart';

/// WorkPackageBudgetEstimateLine
///
/// Properties:
/// * [index] - Position of the line in the request.
/// * [status]
/// * [averageUnitPriceCentavos]
/// * [amountCentavos]
/// * [vendorCount]
@BuiltValue()
abstract class WorkPackageBudgetEstimateLine implements Built<WorkPackageBudgetEstimateLine, WorkPackageBudgetEstimateLineBuilder> {
  /// Position of the line in the request.
  @BuiltValueField(wireName: r'index')
  int get index;

  @BuiltValueField(wireName: r'status')
  WorkPackageBudgetEstimateLineStatusEnum get status;
  // enum statusEnum {  PRICED,  NO_PRICE_DATA,  UNLISTED,  };

  @BuiltValueField(wireName: r'average_unit_price_centavos')
  int? get averageUnitPriceCentavos;

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  WorkPackageBudgetEstimateLine._();

  factory WorkPackageBudgetEstimateLine([void updates(WorkPackageBudgetEstimateLineBuilder b)]) = _$WorkPackageBudgetEstimateLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageBudgetEstimateLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageBudgetEstimateLine> get serializer => _$WorkPackageBudgetEstimateLineSerializer();
}

class _$WorkPackageBudgetEstimateLineSerializer implements PrimitiveSerializer<WorkPackageBudgetEstimateLine> {
  @override
  final Iterable<Type> types = const [WorkPackageBudgetEstimateLine, _$WorkPackageBudgetEstimateLine];

  @override
  final String wireName = r'WorkPackageBudgetEstimateLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageBudgetEstimateLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'index';
    yield serializers.serialize(
      object.index,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WorkPackageBudgetEstimateLineStatusEnum),
    );
    if (object.averageUnitPriceCentavos != null) {
      yield r'average_unit_price_centavos';
      yield serializers.serialize(
        object.averageUnitPriceCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.amountCentavos != null) {
      yield r'amount_centavos';
      yield serializers.serialize(
        object.amountCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageBudgetEstimateLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageBudgetEstimateLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.index = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageBudgetEstimateLineStatusEnum),
          ) as WorkPackageBudgetEstimateLineStatusEnum;
          result.status = valueDes;
          break;
        case r'average_unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.averageUnitPriceCentavos = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountCentavos = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageBudgetEstimateLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageBudgetEstimateLineBuilder();
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


class WorkPackageBudgetEstimateLineStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRICED')
  static const WorkPackageBudgetEstimateLineStatusEnum PRICED = _$workPackageBudgetEstimateLineStatusEnum_PRICED;
  @BuiltValueEnumConst(wireName: r'NO_PRICE_DATA')
  static const WorkPackageBudgetEstimateLineStatusEnum NO_PRICE_DATA = _$workPackageBudgetEstimateLineStatusEnum_NO_PRICE_DATA;
  @BuiltValueEnumConst(wireName: r'UNLISTED')
  static const WorkPackageBudgetEstimateLineStatusEnum UNLISTED = _$workPackageBudgetEstimateLineStatusEnum_UNLISTED;

  static Serializer<WorkPackageBudgetEstimateLineStatusEnum> get serializer => _$workPackageBudgetEstimateLineStatusEnumSerializer;

  const WorkPackageBudgetEstimateLineStatusEnum._(String name): super(name);

  static BuiltSet<WorkPackageBudgetEstimateLineStatusEnum> get values => _$workPackageBudgetEstimateLineStatusEnumValues;
  static WorkPackageBudgetEstimateLineStatusEnum valueOf(String name) => _$workPackageBudgetEstimateLineStatusEnumValueOf(name);
}

