//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_setup_draft_delivery.g.dart';

/// VendorSetupDraftDelivery
///
/// Properties:
/// * [maximumDistanceKm]
/// * [coverageNotes]
@BuiltValue()
abstract class VendorSetupDraftDelivery implements Built<VendorSetupDraftDelivery, VendorSetupDraftDeliveryBuilder> {
  @BuiltValueField(wireName: r'maximum_distance_km')
  int? get maximumDistanceKm;

  @BuiltValueField(wireName: r'coverage_notes')
  String? get coverageNotes;

  VendorSetupDraftDelivery._();

  factory VendorSetupDraftDelivery([void updates(VendorSetupDraftDeliveryBuilder b)]) = _$VendorSetupDraftDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorSetupDraftDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorSetupDraftDelivery> get serializer => _$VendorSetupDraftDeliverySerializer();
}

class _$VendorSetupDraftDeliverySerializer implements PrimitiveSerializer<VendorSetupDraftDelivery> {
  @override
  final Iterable<Type> types = const [VendorSetupDraftDelivery, _$VendorSetupDraftDelivery];

  @override
  final String wireName = r'VendorSetupDraftDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorSetupDraftDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.maximumDistanceKm != null) {
      yield r'maximum_distance_km';
      yield serializers.serialize(
        object.maximumDistanceKm,
        specifiedType: const FullType(int),
      );
    }
    if (object.coverageNotes != null) {
      yield r'coverage_notes';
      yield serializers.serialize(
        object.coverageNotes,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorSetupDraftDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorSetupDraftDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'maximum_distance_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maximumDistanceKm = valueDes;
          break;
        case r'coverage_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.coverageNotes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorSetupDraftDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorSetupDraftDeliveryBuilder();
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


