//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_vendor_store_refund_configuration.g.dart';

/// SaveVendorStoreRefundConfiguration
///
/// Properties:
/// * [onlineRefundSupported]
/// * [physicalReimbursementSupported]
@BuiltValue()
abstract class SaveVendorStoreRefundConfiguration implements Built<SaveVendorStoreRefundConfiguration, SaveVendorStoreRefundConfigurationBuilder> {
  @BuiltValueField(wireName: r'online_refund_supported')
  bool get onlineRefundSupported;

  @BuiltValueField(wireName: r'physical_reimbursement_supported')
  bool get physicalReimbursementSupported;

  SaveVendorStoreRefundConfiguration._();

  factory SaveVendorStoreRefundConfiguration([void updates(SaveVendorStoreRefundConfigurationBuilder b)]) = _$SaveVendorStoreRefundConfiguration;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveVendorStoreRefundConfigurationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveVendorStoreRefundConfiguration> get serializer => _$SaveVendorStoreRefundConfigurationSerializer();
}

class _$SaveVendorStoreRefundConfigurationSerializer implements PrimitiveSerializer<SaveVendorStoreRefundConfiguration> {
  @override
  final Iterable<Type> types = const [SaveVendorStoreRefundConfiguration, _$SaveVendorStoreRefundConfiguration];

  @override
  final String wireName = r'SaveVendorStoreRefundConfiguration';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveVendorStoreRefundConfiguration object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'online_refund_supported';
    yield serializers.serialize(
      object.onlineRefundSupported,
      specifiedType: const FullType(bool),
    );
    yield r'physical_reimbursement_supported';
    yield serializers.serialize(
      object.physicalReimbursementSupported,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveVendorStoreRefundConfiguration object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveVendorStoreRefundConfigurationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'online_refund_supported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.onlineRefundSupported = valueDes;
          break;
        case r'physical_reimbursement_supported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.physicalReimbursementSupported = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaveVendorStoreRefundConfiguration deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveVendorStoreRefundConfigurationBuilder();
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


