//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_tin_reveal.g.dart';

/// VendorTinReveal
///
/// Properties:
/// * [tin] - The store's full TIN and branch code, formatted as 123-456-789-000. Sensitive: render only on an explicit Owner action and never store, log or cache it.
@BuiltValue()
abstract class VendorTinReveal implements Built<VendorTinReveal, VendorTinRevealBuilder> {
  /// The store's full TIN and branch code, formatted as 123-456-789-000. Sensitive: render only on an explicit Owner action and never store, log or cache it.
  @BuiltValueField(wireName: r'tin')
  String get tin;

  VendorTinReveal._();

  factory VendorTinReveal([void updates(VendorTinRevealBuilder b)]) = _$VendorTinReveal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTinRevealBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTinReveal> get serializer => _$VendorTinRevealSerializer();
}

class _$VendorTinRevealSerializer implements PrimitiveSerializer<VendorTinReveal> {
  @override
  final Iterable<Type> types = const [VendorTinReveal, _$VendorTinReveal];

  @override
  final String wireName = r'VendorTinReveal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTinReveal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tin';
    yield serializers.serialize(
      object.tin,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTinReveal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTinRevealBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTinReveal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTinRevealBuilder();
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


