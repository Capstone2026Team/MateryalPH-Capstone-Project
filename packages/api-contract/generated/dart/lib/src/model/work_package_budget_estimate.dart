//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/work_package_budget_estimate_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_budget_estimate.g.dart';

/// WorkPackageBudgetEstimate
///
/// Properties:
/// * [lines]
/// * [materialsTotalCentavos]
/// * [pricedLineCount]
/// * [unpricedLineCount]
/// * [radiusKm]
/// * [basis]
/// * [excludes]
/// * [computedAt]
@BuiltValue()
abstract class WorkPackageBudgetEstimate implements Built<WorkPackageBudgetEstimate, WorkPackageBudgetEstimateBuilder> {
  @BuiltValueField(wireName: r'lines')
  BuiltList<WorkPackageBudgetEstimateLine> get lines;

  @BuiltValueField(wireName: r'materials_total_centavos')
  int get materialsTotalCentavos;

  @BuiltValueField(wireName: r'priced_line_count')
  int get pricedLineCount;

  @BuiltValueField(wireName: r'unpriced_line_count')
  int get unpricedLineCount;

  @BuiltValueField(wireName: r'radius_km')
  int get radiusKm;

  @BuiltValueField(wireName: r'basis')
  WorkPackageBudgetEstimateBasisEnum get basis;
  // enum basisEnum {  AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE,  };

  @BuiltValueField(wireName: r'excludes')
  BuiltList<String> get excludes;

  @BuiltValueField(wireName: r'computed_at')
  String get computedAt;

  WorkPackageBudgetEstimate._();

  factory WorkPackageBudgetEstimate([void updates(WorkPackageBudgetEstimateBuilder b)]) = _$WorkPackageBudgetEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageBudgetEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageBudgetEstimate> get serializer => _$WorkPackageBudgetEstimateSerializer();
}

class _$WorkPackageBudgetEstimateSerializer implements PrimitiveSerializer<WorkPackageBudgetEstimate> {
  @override
  final Iterable<Type> types = const [WorkPackageBudgetEstimate, _$WorkPackageBudgetEstimate];

  @override
  final String wireName = r'WorkPackageBudgetEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageBudgetEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageBudgetEstimateLine)]),
    );
    yield r'materials_total_centavos';
    yield serializers.serialize(
      object.materialsTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'priced_line_count';
    yield serializers.serialize(
      object.pricedLineCount,
      specifiedType: const FullType(int),
    );
    yield r'unpriced_line_count';
    yield serializers.serialize(
      object.unpricedLineCount,
      specifiedType: const FullType(int),
    );
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(int),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(WorkPackageBudgetEstimateBasisEnum),
    );
    yield r'excludes';
    yield serializers.serialize(
      object.excludes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'computed_at';
    yield serializers.serialize(
      object.computedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageBudgetEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageBudgetEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageBudgetEstimateLine)]),
          ) as BuiltList<WorkPackageBudgetEstimateLine>;
          result.lines.replace(valueDes);
          break;
        case r'materials_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsTotalCentavos = valueDes;
          break;
        case r'priced_line_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pricedLineCount = valueDes;
          break;
        case r'unpriced_line_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unpricedLineCount = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.radiusKm = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageBudgetEstimateBasisEnum),
          ) as WorkPackageBudgetEstimateBasisEnum;
          result.basis = valueDes;
          break;
        case r'excludes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.excludes.replace(valueDes);
          break;
        case r'computed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.computedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageBudgetEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageBudgetEstimateBuilder();
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


class WorkPackageBudgetEstimateBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE')
  static const WorkPackageBudgetEstimateBasisEnum AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE = _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE;

  static Serializer<WorkPackageBudgetEstimateBasisEnum> get serializer => _$workPackageBudgetEstimateBasisEnumSerializer;

  const WorkPackageBudgetEstimateBasisEnum._(String name): super(name);

  static BuiltSet<WorkPackageBudgetEstimateBasisEnum> get values => _$workPackageBudgetEstimateBasisEnumValues;
  static WorkPackageBudgetEstimateBasisEnum valueOf(String name) => _$workPackageBudgetEstimateBasisEnumValueOf(name);
}

