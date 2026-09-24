//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_restriction.g.dart';

/// VendorRestriction
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class VendorRestriction implements Built<VendorRestriction, VendorRestrictionBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  VendorRestriction._();

  factory VendorRestriction([void updates(VendorRestrictionBuilder b)]) = _$VendorRestriction;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorRestrictionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorRestriction> get serializer => _$VendorRestrictionSerializer();
}

class _$VendorRestrictionSerializer implements PrimitiveSerializer<VendorRestriction> {
  @override
  final Iterable<Type> types = const [VendorRestriction, _$VendorRestriction];

  @override
  final String wireName = r'VendorRestriction';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorRestriction object, {
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
    VendorRestriction object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorRestrictionBuilder result,
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
  VendorRestriction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorRestrictionBuilder();
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


