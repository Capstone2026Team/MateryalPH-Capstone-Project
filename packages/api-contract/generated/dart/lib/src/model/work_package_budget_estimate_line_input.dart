//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_budget_estimate_line_input.g.dart';

/// WorkPackageBudgetEstimateLineInput
///
/// Properties:
/// * [materialId]
/// * [unitId]
/// * [quantity]
/// * [preferredBrand]
/// * [specifications]
@BuiltValue()
abstract class WorkPackageBudgetEstimateLineInput implements Built<WorkPackageBudgetEstimateLineInput, WorkPackageBudgetEstimateLineInputBuilder> {
  @BuiltValueField(wireName: r'material_id')
  String? get materialId;

  @BuiltValueField(wireName: r'unit_id')
  String get unitId;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'preferred_brand')
  String? get preferredBrand;

  @BuiltValueField(wireName: r'specifications')
  BuiltMap<String, String> get specifications;

  WorkPackageBudgetEstimateLineInput._();

  factory WorkPackageBudgetEstimateLineInput([void updates(WorkPackageBudgetEstimateLineInputBuilder b)]) = _$WorkPackageBudgetEstimateLineInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageBudgetEstimateLineInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageBudgetEstimateLineInput> get serializer => _$WorkPackageBudgetEstimateLineInputSerializer();
}

class _$WorkPackageBudgetEstimateLineInputSerializer implements PrimitiveSerializer<WorkPackageBudgetEstimateLineInput> {
  @override
  final Iterable<Type> types = const [WorkPackageBudgetEstimateLineInput, _$WorkPackageBudgetEstimateLineInput];

  @override
  final String wireName = r'WorkPackageBudgetEstimateLineInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageBudgetEstimateLineInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.materialId != null) {
      yield r'material_id';
      yield serializers.serialize(
        object.materialId,
        specifiedType: const FullType(String),
      );
    }
    yield r'unit_id';
    yield serializers.serialize(
      object.unitId,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    if (object.preferredBrand != null) {
      yield r'preferred_brand';
      yield serializers.serialize(
        object.preferredBrand,
        specifiedType: const FullType(String),
      );
    }
    yield r'specifications';
    yield serializers.serialize(
      object.specifications,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageBudgetEstimateLineInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageBudgetEstimateLineInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'material_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.materialId = valueDes;
          break;
        case r'unit_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitId = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'preferred_brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.preferredBrand = valueDes;
          break;
        case r'specifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.specifications.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageBudgetEstimateLineInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageBudgetEstimateLineInputBuilder();
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


