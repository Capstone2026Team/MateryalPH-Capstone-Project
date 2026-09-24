//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/store_activation_readiness.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_activation_snapshot.g.dart';

/// VendorActivationSnapshot
///
/// Properties:
/// * [status]
/// * [marketplaceDiscoverabilityStatus]
/// * [readiness]
@BuiltValue()
abstract class VendorActivationSnapshot implements Built<VendorActivationSnapshot, VendorActivationSnapshotBuilder> {
  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'marketplace_discoverability_status')
  String get marketplaceDiscoverabilityStatus;

  @BuiltValueField(wireName: r'readiness')
  StoreActivationReadiness get readiness;

  VendorActivationSnapshot._();

  factory VendorActivationSnapshot([void updates(VendorActivationSnapshotBuilder b)]) = _$VendorActivationSnapshot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorActivationSnapshotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorActivationSnapshot> get serializer => _$VendorActivationSnapshotSerializer();
}

class _$VendorActivationSnapshotSerializer implements PrimitiveSerializer<VendorActivationSnapshot> {
  @override
  final Iterable<Type> types = const [VendorActivationSnapshot, _$VendorActivationSnapshot];

  @override
  final String wireName = r'VendorActivationSnapshot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorActivationSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'marketplace_discoverability_status';
    yield serializers.serialize(
      object.marketplaceDiscoverabilityStatus,
      specifiedType: const FullType(String),
    );
    yield r'readiness';
    yield serializers.serialize(
      object.readiness,
      specifiedType: const FullType(StoreActivationReadiness),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorActivationSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorActivationSnapshotBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'marketplace_discoverability_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.marketplaceDiscoverabilityStatus = valueDes;
          break;
        case r'readiness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoreActivationReadiness),
          ) as StoreActivationReadiness;
          result.readiness.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorActivationSnapshot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorActivationSnapshotBuilder();
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


