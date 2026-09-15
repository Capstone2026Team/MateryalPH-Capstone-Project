//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'accept_vendor_commission.g.dart';

/// AcceptVendorCommission
///
/// Properties:
/// * [versionId]
@BuiltValue()
abstract class AcceptVendorCommission implements Built<AcceptVendorCommission, AcceptVendorCommissionBuilder> {
  @BuiltValueField(wireName: r'version_id')
  String get versionId;

  AcceptVendorCommission._();

  factory AcceptVendorCommission([void updates(AcceptVendorCommissionBuilder b)]) = _$AcceptVendorCommission;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcceptVendorCommissionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AcceptVendorCommission> get serializer => _$AcceptVendorCommissionSerializer();
}

class _$AcceptVendorCommissionSerializer implements PrimitiveSerializer<AcceptVendorCommission> {
  @override
  final Iterable<Type> types = const [AcceptVendorCommission, _$AcceptVendorCommission];

  @override
  final String wireName = r'AcceptVendorCommission';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AcceptVendorCommission object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version_id';
    yield serializers.serialize(
      object.versionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AcceptVendorCommission object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AcceptVendorCommissionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.versionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AcceptVendorCommission deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcceptVendorCommissionBuilder();
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


