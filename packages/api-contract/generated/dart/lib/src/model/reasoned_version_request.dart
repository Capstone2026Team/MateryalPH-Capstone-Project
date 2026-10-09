//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reasoned_version_request.g.dart';

/// ReasonedVersionRequest
///
/// Properties:
/// * [lockVersion]
/// * [reason]
@BuiltValue()
abstract class ReasonedVersionRequest implements Built<ReasonedVersionRequest, ReasonedVersionRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  ReasonedVersionRequest._();

  factory ReasonedVersionRequest([void updates(ReasonedVersionRequestBuilder b)]) = _$ReasonedVersionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReasonedVersionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReasonedVersionRequest> get serializer => _$ReasonedVersionRequestSerializer();
}

class _$ReasonedVersionRequestSerializer implements PrimitiveSerializer<ReasonedVersionRequest> {
  @override
  final Iterable<Type> types = const [ReasonedVersionRequest, _$ReasonedVersionRequest];

  @override
  final String wireName = r'ReasonedVersionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReasonedVersionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReasonedVersionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReasonedVersionRequestBuilder result,
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
  ReasonedVersionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReasonedVersionRequestBuilder();
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


