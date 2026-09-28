//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_resume.g.dart';

/// AutoAcceptResume
///
/// Properties:
/// * [lockVersion]
/// * [confirmedAllotmentQuantity] - The remaining allotment named in the resume confirmation.
@BuiltValue()
abstract class AutoAcceptResume implements Built<AutoAcceptResume, AutoAcceptResumeBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  /// The remaining allotment named in the resume confirmation.
  @BuiltValueField(wireName: r'confirmed_allotment_quantity')
  String get confirmedAllotmentQuantity;

  AutoAcceptResume._();

  factory AutoAcceptResume([void updates(AutoAcceptResumeBuilder b)]) = _$AutoAcceptResume;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptResumeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptResume> get serializer => _$AutoAcceptResumeSerializer();
}

class _$AutoAcceptResumeSerializer implements PrimitiveSerializer<AutoAcceptResume> {
  @override
  final Iterable<Type> types = const [AutoAcceptResume, _$AutoAcceptResume];

  @override
  final String wireName = r'AutoAcceptResume';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptResume object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'confirmed_allotment_quantity';
    yield serializers.serialize(
      object.confirmedAllotmentQuantity,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptResume object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptResumeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'confirmed_allotment_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.confirmedAllotmentQuantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptResume deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptResumeBuilder();
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


