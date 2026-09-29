//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/supplier_open_status.dart';
import 'package:materyalph_api_client/src/model/public_address_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_vendor_ref.g.dart';

/// CheckoutVendorRef
///
/// Properties:
/// * [id]
/// * [name]
/// * [logoUrl]
/// * [address]
/// * [openStatus]
@BuiltValue()
abstract class CheckoutVendorRef implements Built<CheckoutVendorRef, CheckoutVendorRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'logo_url')
  String? get logoUrl;

  @BuiltValueField(wireName: r'address')
  PublicAddressSummary? get address;

  @BuiltValueField(wireName: r'open_status')
  SupplierOpenStatus? get openStatus;

  CheckoutVendorRef._();

  factory CheckoutVendorRef([void updates(CheckoutVendorRefBuilder b)]) = _$CheckoutVendorRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutVendorRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutVendorRef> get serializer => _$CheckoutVendorRefSerializer();
}

class _$CheckoutVendorRefSerializer implements PrimitiveSerializer<CheckoutVendorRef> {
  @override
  final Iterable<Type> types = const [CheckoutVendorRef, _$CheckoutVendorRef];

  @override
  final String wireName = r'CheckoutVendorRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutVendorRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'logo_url';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield object.address == null ? null : serializers.serialize(
      object.address,
      specifiedType: const FullType.nullable(PublicAddressSummary),
    );
    yield r'open_status';
    yield object.openStatus == null ? null : serializers.serialize(
      object.openStatus,
      specifiedType: const FullType.nullable(SupplierOpenStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutVendorRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutVendorRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'logo_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PublicAddressSummary),
          ) as PublicAddressSummary?;
          if (valueDes == null) continue;
          result.address.replace(valueDes);
          break;
        case r'open_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SupplierOpenStatus),
          ) as SupplierOpenStatus?;
          if (valueDes == null) continue;
          result.openStatus.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutVendorRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutVendorRefBuilder();
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


