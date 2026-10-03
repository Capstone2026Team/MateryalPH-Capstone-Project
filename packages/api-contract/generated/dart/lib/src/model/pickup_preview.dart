//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/supplier_open_status.dart';
import 'package:materyalph_api_client/src/model/public_address_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pickup_preview.g.dart';

/// PickupPreview
///
/// Properties:
/// * [address]
/// * [openStatus]
/// * [notice]
@BuiltValue()
abstract class PickupPreview implements Built<PickupPreview, PickupPreviewBuilder> {
  @BuiltValueField(wireName: r'address')
  PublicAddressSummary? get address;

  @BuiltValueField(wireName: r'open_status')
  SupplierOpenStatus? get openStatus;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  PickupPreview._();

  factory PickupPreview([void updates(PickupPreviewBuilder b)]) = _$PickupPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PickupPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PickupPreview> get serializer => _$PickupPreviewSerializer();
}

class _$PickupPreviewSerializer implements PrimitiveSerializer<PickupPreview> {
  @override
  final Iterable<Type> types = const [PickupPreview, _$PickupPreview];

  @override
  final String wireName = r'PickupPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PickupPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PickupPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PickupPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PickupPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PickupPreviewBuilder();
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


