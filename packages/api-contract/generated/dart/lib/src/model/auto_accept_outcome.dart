//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/auto_accept_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_outcome.g.dart';

/// AutoAcceptOutcome
///
/// Properties:
/// * [accepted]
/// * [routedTo]
/// * [reasons]
/// * [ruleVersion]
/// * [evaluatedAt]
@BuiltValue()
abstract class AutoAcceptOutcome implements Built<AutoAcceptOutcome, AutoAcceptOutcomeBuilder> {
  @BuiltValueField(wireName: r'accepted')
  bool get accepted;

  @BuiltValueField(wireName: r'routed_to')
  AutoAcceptOutcomeRoutedToEnum? get routedTo;
  // enum routedToEnum {  MANUAL_REVIEW,  };

  @BuiltValueField(wireName: r'reasons')
  BuiltList<AutoAcceptReason> get reasons;

  @BuiltValueField(wireName: r'rule_version')
  String get ruleVersion;

  @BuiltValueField(wireName: r'evaluated_at')
  DateTime get evaluatedAt;

  AutoAcceptOutcome._();

  factory AutoAcceptOutcome([void updates(AutoAcceptOutcomeBuilder b)]) = _$AutoAcceptOutcome;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptOutcomeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptOutcome> get serializer => _$AutoAcceptOutcomeSerializer();
}

class _$AutoAcceptOutcomeSerializer implements PrimitiveSerializer<AutoAcceptOutcome> {
  @override
  final Iterable<Type> types = const [AutoAcceptOutcome, _$AutoAcceptOutcome];

  @override
  final String wireName = r'AutoAcceptOutcome';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptOutcome object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(bool),
    );
    if (object.routedTo != null) {
      yield r'routed_to';
      yield serializers.serialize(
        object.routedTo,
        specifiedType: const FullType(AutoAcceptOutcomeRoutedToEnum),
      );
    }
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(AutoAcceptReason)]),
    );
    yield r'rule_version';
    yield serializers.serialize(
      object.ruleVersion,
      specifiedType: const FullType(String),
    );
    yield r'evaluated_at';
    yield serializers.serialize(
      object.evaluatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptOutcome object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptOutcomeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accepted = valueDes;
          break;
        case r'routed_to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AutoAcceptOutcomeRoutedToEnum),
          ) as AutoAcceptOutcomeRoutedToEnum?;
          if (valueDes == null) continue;
          result.routedTo = valueDes;
          break;
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AutoAcceptReason)]),
          ) as BuiltList<AutoAcceptReason>;
          result.reasons.replace(valueDes);
          break;
        case r'rule_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ruleVersion = valueDes;
          break;
        case r'evaluated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.evaluatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptOutcome deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptOutcomeBuilder();
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


class AutoAcceptOutcomeRoutedToEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MANUAL_REVIEW')
  static const AutoAcceptOutcomeRoutedToEnum MANUAL_REVIEW = _$autoAcceptOutcomeRoutedToEnum_MANUAL_REVIEW;

  static Serializer<AutoAcceptOutcomeRoutedToEnum> get serializer => _$autoAcceptOutcomeRoutedToEnumSerializer;

  const AutoAcceptOutcomeRoutedToEnum._(String name): super(name);

  static BuiltSet<AutoAcceptOutcomeRoutedToEnum> get values => _$autoAcceptOutcomeRoutedToEnumValues;
  static AutoAcceptOutcomeRoutedToEnum valueOf(String name) => _$autoAcceptOutcomeRoutedToEnumValueOf(name);
}

