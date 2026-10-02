//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_budget.g.dart';

/// ProjectBudget
///
/// Properties:
/// * [budgetCentavos]
/// * [pendingCentavos]
/// * [actualCentavos]
/// * [awaitingRecoveryCentavos]
/// * [committedCentavos]
/// * [remainingCentavos]
/// * [utilizationPercent]
/// * [warning]
/// * [label]
/// * [allocatedCentavos]
/// * [unallocatedCentavos]
/// * [pendingConfirmationCount]
/// * [processingFeeStatus]
@BuiltValue()
abstract class ProjectBudget implements Built<ProjectBudget, ProjectBudgetBuilder> {
  @BuiltValueField(wireName: r'budget_centavos')
  int get budgetCentavos;

  @BuiltValueField(wireName: r'pending_centavos')
  int get pendingCentavos;

  @BuiltValueField(wireName: r'actual_centavos')
  int get actualCentavos;

  @BuiltValueField(wireName: r'awaiting_recovery_centavos')
  int get awaitingRecoveryCentavos;

  @BuiltValueField(wireName: r'committed_centavos')
  int get committedCentavos;

  @BuiltValueField(wireName: r'remaining_centavos')
  int get remainingCentavos;

  @BuiltValueField(wireName: r'utilization_percent')
  String get utilizationPercent;

  @BuiltValueField(wireName: r'warning')
  bool get warning;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'allocated_centavos')
  int get allocatedCentavos;

  @BuiltValueField(wireName: r'unallocated_centavos')
  int get unallocatedCentavos;

  @BuiltValueField(wireName: r'pending_confirmation_count')
  int get pendingConfirmationCount;

  @BuiltValueField(wireName: r'processing_fee_status')
  String get processingFeeStatus;

  ProjectBudget._();

  factory ProjectBudget([void updates(ProjectBudgetBuilder b)]) = _$ProjectBudget;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectBudgetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectBudget> get serializer => _$ProjectBudgetSerializer();
}

class _$ProjectBudgetSerializer implements PrimitiveSerializer<ProjectBudget> {
  @override
  final Iterable<Type> types = const [ProjectBudget, _$ProjectBudget];

  @override
  final String wireName = r'ProjectBudget';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectBudget object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'budget_centavos';
    yield serializers.serialize(
      object.budgetCentavos,
      specifiedType: const FullType(int),
    );
    yield r'pending_centavos';
    yield serializers.serialize(
      object.pendingCentavos,
      specifiedType: const FullType(int),
    );
    yield r'actual_centavos';
    yield serializers.serialize(
      object.actualCentavos,
      specifiedType: const FullType(int),
    );
    yield r'awaiting_recovery_centavos';
    yield serializers.serialize(
      object.awaitingRecoveryCentavos,
      specifiedType: const FullType(int),
    );
    yield r'committed_centavos';
    yield serializers.serialize(
      object.committedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'remaining_centavos';
    yield serializers.serialize(
      object.remainingCentavos,
      specifiedType: const FullType(int),
    );
    yield r'utilization_percent';
    yield serializers.serialize(
      object.utilizationPercent,
      specifiedType: const FullType(String),
    );
    yield r'warning';
    yield serializers.serialize(
      object.warning,
      specifiedType: const FullType(bool),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'allocated_centavos';
    yield serializers.serialize(
      object.allocatedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'unallocated_centavos';
    yield serializers.serialize(
      object.unallocatedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'pending_confirmation_count';
    yield serializers.serialize(
      object.pendingConfirmationCount,
      specifiedType: const FullType(int),
    );
    yield r'processing_fee_status';
    yield serializers.serialize(
      object.processingFeeStatus,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectBudget object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectBudgetBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.budgetCentavos = valueDes;
          break;
        case r'pending_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingCentavos = valueDes;
          break;
        case r'actual_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.actualCentavos = valueDes;
          break;
        case r'awaiting_recovery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.awaitingRecoveryCentavos = valueDes;
          break;
        case r'committed_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.committedCentavos = valueDes;
          break;
        case r'remaining_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingCentavos = valueDes;
          break;
        case r'utilization_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.utilizationPercent = valueDes;
          break;
        case r'warning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.warning = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'allocated_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.allocatedCentavos = valueDes;
          break;
        case r'unallocated_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unallocatedCentavos = valueDes;
          break;
        case r'pending_confirmation_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingConfirmationCount = valueDes;
          break;
        case r'processing_fee_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.processingFeeStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectBudget deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectBudgetBuilder();
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


