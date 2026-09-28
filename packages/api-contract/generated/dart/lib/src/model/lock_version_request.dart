//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lock_version_request.g.dart';

/// LockVersionRequest
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class LockVersionRequest implements Built<LockVersionRequest, LockVersionRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  LockVersionRequest._();

  factory LockVersionRequest([void updates(LockVersionRequestBuilder b)]) = _$LockVersionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LockVersionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LockVersionRequest> get serializer => _$LockVersionRequestSerializer();
}

class _$LockVersionRequestSerializer implements PrimitiveSerializer<LockVersionRequest> {
  @override
  final Iterable<Type> types = const [LockVersionRequest, _$LockVersionRequest];

  @override
  final String wireName = r'LockVersionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LockVersionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LockVersionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LockVersionRequestBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LockVersionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LockVersionRequestBuilder();
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


