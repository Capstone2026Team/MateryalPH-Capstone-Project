//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_arrangement_submit_payments_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_arrangement_submit.g.dart';

/// ProjectArrangementSubmit
///
/// Properties:
/// * [version]
/// * [fingerprint]
/// * [acknowledged]
/// * [payments]
/// * [note]
/// * [budgetOverrideReason]
@BuiltValue()
abstract class ProjectArrangementSubmit implements Built<ProjectArrangementSubmit, ProjectArrangementSubmitBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'fingerprint')
  String get fingerprint;

  @BuiltValueField(wireName: r'acknowledged')
  bool get acknowledged;

  @BuiltValueField(wireName: r'payments')
  BuiltList<ProjectArrangementSubmitPaymentsInner> get payments;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  ProjectArrangementSubmit._();

  factory ProjectArrangementSubmit([void updates(ProjectArrangementSubmitBuilder b)]) = _$ProjectArrangementSubmit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArrangementSubmitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArrangementSubmit> get serializer => _$ProjectArrangementSubmitSerializer();
}

class _$ProjectArrangementSubmitSerializer implements PrimitiveSerializer<ProjectArrangementSubmit> {
  @override
  final Iterable<Type> types = const [ProjectArrangementSubmit, _$ProjectArrangementSubmit];

  @override
  final String wireName = r'ProjectArrangementSubmit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArrangementSubmit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'fingerprint';
    yield serializers.serialize(
      object.fingerprint,
      specifiedType: const FullType(String),
    );
    yield r'acknowledged';
    yield serializers.serialize(
      object.acknowledged,
      specifiedType: const FullType(bool),
    );
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(BuiltList, [FullType(ProjectArrangementSubmitPaymentsInner)]),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArrangementSubmit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArrangementSubmitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fingerprint = valueDes;
          break;
        case r'acknowledged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.acknowledged = valueDes;
          break;
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectArrangementSubmitPaymentsInner)]),
          ) as BuiltList<ProjectArrangementSubmitPaymentsInner>;
          result.payments.replace(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArrangementSubmit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArrangementSubmitBuilder();
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


