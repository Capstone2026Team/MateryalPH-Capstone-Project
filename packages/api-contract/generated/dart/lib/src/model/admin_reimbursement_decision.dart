//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reimbursement_decision.g.dart';

/// AdminReimbursementDecision
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class AdminReimbursementDecision implements Built<AdminReimbursementDecision, AdminReimbursementDecisionBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminReimbursementDecision._();

  factory AdminReimbursementDecision([void updates(AdminReimbursementDecisionBuilder b)]) = _$AdminReimbursementDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReimbursementDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReimbursementDecision> get serializer => _$AdminReimbursementDecisionSerializer();
}

class _$AdminReimbursementDecisionSerializer implements PrimitiveSerializer<AdminReimbursementDecision> {
  @override
  final Iterable<Type> types = const [AdminReimbursementDecision, _$AdminReimbursementDecision];

  @override
  final String wireName = r'AdminReimbursementDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReimbursementDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReimbursementDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReimbursementDecisionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReimbursementDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReimbursementDecisionBuilder();
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


