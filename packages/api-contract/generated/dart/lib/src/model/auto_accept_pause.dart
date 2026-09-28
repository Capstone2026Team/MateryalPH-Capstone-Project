//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_pause.g.dart';

/// AutoAcceptPause
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class AutoAcceptPause implements Built<AutoAcceptPause, AutoAcceptPauseBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  AutoAcceptPause._();

  factory AutoAcceptPause([void updates(AutoAcceptPauseBuilder b)]) = _$AutoAcceptPause;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPauseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPause> get serializer => _$AutoAcceptPauseSerializer();
}

class _$AutoAcceptPauseSerializer implements PrimitiveSerializer<AutoAcceptPause> {
  @override
  final Iterable<Type> types = const [AutoAcceptPause, _$AutoAcceptPause];

  @override
  final String wireName = r'AutoAcceptPause';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPause object, {
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
    AutoAcceptPause object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPauseBuilder result,
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
  AutoAcceptPause deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPauseBuilder();
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


