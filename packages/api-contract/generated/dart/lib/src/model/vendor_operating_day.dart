//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_operating_day.g.dart';

/// VendorOperatingDay
///
/// Properties:
/// * [weekday]
/// * [opensAt]
/// * [closesAt]
/// * [closed]
@BuiltValue()
abstract class VendorOperatingDay implements Built<VendorOperatingDay, VendorOperatingDayBuilder> {
  @BuiltValueField(wireName: r'weekday')
  int get weekday;

  @BuiltValueField(wireName: r'opens_at')
  String? get opensAt;

  @BuiltValueField(wireName: r'closes_at')
  String? get closesAt;

  @BuiltValueField(wireName: r'closed')
  bool get closed;

  VendorOperatingDay._();

  factory VendorOperatingDay([void updates(VendorOperatingDayBuilder b)]) = _$VendorOperatingDay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOperatingDayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOperatingDay> get serializer => _$VendorOperatingDaySerializer();
}

class _$VendorOperatingDaySerializer implements PrimitiveSerializer<VendorOperatingDay> {
  @override
  final Iterable<Type> types = const [VendorOperatingDay, _$VendorOperatingDay];

  @override
  final String wireName = r'VendorOperatingDay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOperatingDay object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(int),
    );
    if (object.opensAt != null) {
      yield r'opens_at';
      yield serializers.serialize(
        object.opensAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.closesAt != null) {
      yield r'closes_at';
      yield serializers.serialize(
        object.closesAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'closed';
    yield serializers.serialize(
      object.closed,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOperatingDay object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOperatingDayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.weekday = valueDes;
          break;
        case r'opens_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'closes_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'closed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.closed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOperatingDay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOperatingDayBuilder();
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


