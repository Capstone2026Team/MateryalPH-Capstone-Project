//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_inventory_performance.g.dart';

/// VendorTeamInventoryPerformance
///
/// Properties:
/// * [stockUpdates]
/// * [stockConfirmations]
/// * [listingsCreated]
/// * [listingUpdates]
/// * [complianceSubmissions]
/// * [allotmentUpdates]
/// * [unsuccessful]
@BuiltValue()
abstract class VendorTeamInventoryPerformance implements Built<VendorTeamInventoryPerformance, VendorTeamInventoryPerformanceBuilder> {
  @BuiltValueField(wireName: r'stock_updates')
  int get stockUpdates;

  @BuiltValueField(wireName: r'stock_confirmations')
  int get stockConfirmations;

  @BuiltValueField(wireName: r'listings_created')
  int get listingsCreated;

  @BuiltValueField(wireName: r'listing_updates')
  int get listingUpdates;

  @BuiltValueField(wireName: r'compliance_submissions')
  int get complianceSubmissions;

  @BuiltValueField(wireName: r'allotment_updates')
  int get allotmentUpdates;

  @BuiltValueField(wireName: r'unsuccessful')
  int get unsuccessful;

  VendorTeamInventoryPerformance._();

  factory VendorTeamInventoryPerformance([void updates(VendorTeamInventoryPerformanceBuilder b)]) = _$VendorTeamInventoryPerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamInventoryPerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamInventoryPerformance> get serializer => _$VendorTeamInventoryPerformanceSerializer();
}

class _$VendorTeamInventoryPerformanceSerializer implements PrimitiveSerializer<VendorTeamInventoryPerformance> {
  @override
  final Iterable<Type> types = const [VendorTeamInventoryPerformance, _$VendorTeamInventoryPerformance];

  @override
  final String wireName = r'VendorTeamInventoryPerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamInventoryPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stock_updates';
    yield serializers.serialize(
      object.stockUpdates,
      specifiedType: const FullType(int),
    );
    yield r'stock_confirmations';
    yield serializers.serialize(
      object.stockConfirmations,
      specifiedType: const FullType(int),
    );
    yield r'listings_created';
    yield serializers.serialize(
      object.listingsCreated,
      specifiedType: const FullType(int),
    );
    yield r'listing_updates';
    yield serializers.serialize(
      object.listingUpdates,
      specifiedType: const FullType(int),
    );
    yield r'compliance_submissions';
    yield serializers.serialize(
      object.complianceSubmissions,
      specifiedType: const FullType(int),
    );
    yield r'allotment_updates';
    yield serializers.serialize(
      object.allotmentUpdates,
      specifiedType: const FullType(int),
    );
    yield r'unsuccessful';
    yield serializers.serialize(
      object.unsuccessful,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamInventoryPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamInventoryPerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stock_updates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stockUpdates = valueDes;
          break;
        case r'stock_confirmations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stockConfirmations = valueDes;
          break;
        case r'listings_created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listingsCreated = valueDes;
          break;
        case r'listing_updates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listingUpdates = valueDes;
          break;
        case r'compliance_submissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.complianceSubmissions = valueDes;
          break;
        case r'allotment_updates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.allotmentUpdates = valueDes;
          break;
        case r'unsuccessful':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unsuccessful = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamInventoryPerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamInventoryPerformanceBuilder();
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


