//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_staff_dispute_setting.g.dart';

/// VendorStaffDisputeSetting
///
/// Properties:
/// * [enabled]
/// * [lockVersion]
@BuiltValue()
abstract class VendorStaffDisputeSetting implements Built<VendorStaffDisputeSetting, VendorStaffDisputeSettingBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  VendorStaffDisputeSetting._();

  factory VendorStaffDisputeSetting([void updates(VendorStaffDisputeSettingBuilder b)]) = _$VendorStaffDisputeSetting;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorStaffDisputeSettingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorStaffDisputeSetting> get serializer => _$VendorStaffDisputeSettingSerializer();
}

class _$VendorStaffDisputeSettingSerializer implements PrimitiveSerializer<VendorStaffDisputeSetting> {
  @override
  final Iterable<Type> types = const [VendorStaffDisputeSetting, _$VendorStaffDisputeSetting];

  @override
  final String wireName = r'VendorStaffDisputeSetting';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorStaffDisputeSetting object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorStaffDisputeSetting object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorStaffDisputeSettingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
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
  VendorStaffDisputeSetting deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorStaffDisputeSettingBuilder();
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


