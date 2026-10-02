//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'overlap_resolve_request.g.dart';

/// OverlapResolveRequest
///
/// Properties:
/// * [overlapCentavos]
/// * [lockVersion]
/// * [reason]
@BuiltValue()
abstract class OverlapResolveRequest implements Built<OverlapResolveRequest, OverlapResolveRequestBuilder> {
  @BuiltValueField(wireName: r'overlap_centavos')
  int get overlapCentavos;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  OverlapResolveRequest._();

  factory OverlapResolveRequest([void updates(OverlapResolveRequestBuilder b)]) = _$OverlapResolveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OverlapResolveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OverlapResolveRequest> get serializer => _$OverlapResolveRequestSerializer();
}

class _$OverlapResolveRequestSerializer implements PrimitiveSerializer<OverlapResolveRequest> {
  @override
  final Iterable<Type> types = const [OverlapResolveRequest, _$OverlapResolveRequest];

  @override
  final String wireName = r'OverlapResolveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OverlapResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'overlap_centavos';
    yield serializers.serialize(
      object.overlapCentavos,
      specifiedType: const FullType(int),
    );
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
    OverlapResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OverlapResolveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'overlap_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.overlapCentavos = valueDes;
          break;
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
  OverlapResolveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OverlapResolveRequestBuilder();
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


