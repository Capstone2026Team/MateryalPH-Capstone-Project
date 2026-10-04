//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dispute_handler_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_handler.g.dart';

/// DisputeHandler
///
/// Properties:
/// * [vendor]
/// * [adminAssigned]
/// * [adminIsMe]
@BuiltValue()
abstract class DisputeHandler implements Built<DisputeHandler, DisputeHandlerBuilder> {
  @BuiltValueField(wireName: r'vendor')
  DisputeHandlerRef? get vendor;

  @BuiltValueField(wireName: r'admin_assigned')
  bool get adminAssigned;

  @BuiltValueField(wireName: r'admin_is_me')
  bool get adminIsMe;

  DisputeHandler._();

  factory DisputeHandler([void updates(DisputeHandlerBuilder b)]) = _$DisputeHandler;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeHandlerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeHandler> get serializer => _$DisputeHandlerSerializer();
}

class _$DisputeHandlerSerializer implements PrimitiveSerializer<DisputeHandler> {
  @override
  final Iterable<Type> types = const [DisputeHandler, _$DisputeHandler];

  @override
  final String wireName = r'DisputeHandler';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeHandler object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.vendor != null) {
      yield r'vendor';
      yield serializers.serialize(
        object.vendor,
        specifiedType: const FullType.nullable(DisputeHandlerRef),
      );
    }
    yield r'admin_assigned';
    yield serializers.serialize(
      object.adminAssigned,
      specifiedType: const FullType(bool),
    );
    yield r'admin_is_me';
    yield serializers.serialize(
      object.adminIsMe,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeHandler object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeHandlerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeHandlerRef),
          ) as DisputeHandlerRef?;
          if (valueDes == null) continue;
          result.vendor.replace(valueDes);
          break;
        case r'admin_assigned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.adminAssigned = valueDes;
          break;
        case r'admin_is_me':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.adminIsMe = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeHandler deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeHandlerBuilder();
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


