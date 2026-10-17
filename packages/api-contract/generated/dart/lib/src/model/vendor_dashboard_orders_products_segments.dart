//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_products_segments_points_inner.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_segment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_products_segments.g.dart';

/// K-Means demand groups of the store’s own products.
///
/// Properties:
/// * [state]
/// * [reason]
/// * [k]
/// * [silhouette]
/// * [features]
/// * [segments]
/// * [points]
@BuiltValue()
abstract class VendorDashboardOrdersProductsSegments implements Built<VendorDashboardOrdersProductsSegments, VendorDashboardOrdersProductsSegmentsBuilder> {
  @BuiltValueField(wireName: r'state')
  VendorDashboardOrdersProductsSegmentsStateEnum get state;
  // enum stateEnum {  OK,  INSUFFICIENT_DATA,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'k')
  int? get k;

  @BuiltValueField(wireName: r'silhouette')
  num? get silhouette;

  @BuiltValueField(wireName: r'features')
  BuiltList<String> get features;

  @BuiltValueField(wireName: r'segments')
  BuiltList<VendorDashboardSegment> get segments;

  @BuiltValueField(wireName: r'points')
  BuiltList<VendorDashboardOrdersProductsSegmentsPointsInner> get points;

  VendorDashboardOrdersProductsSegments._();

  factory VendorDashboardOrdersProductsSegments([void updates(VendorDashboardOrdersProductsSegmentsBuilder b)]) = _$VendorDashboardOrdersProductsSegments;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersProductsSegmentsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersProductsSegments> get serializer => _$VendorDashboardOrdersProductsSegmentsSerializer();
}

class _$VendorDashboardOrdersProductsSegmentsSerializer implements PrimitiveSerializer<VendorDashboardOrdersProductsSegments> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersProductsSegments, _$VendorDashboardOrdersProductsSegments];

  @override
  final String wireName = r'VendorDashboardOrdersProductsSegments';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersProductsSegments object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(VendorDashboardOrdersProductsSegmentsStateEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.k != null) {
      yield r'k';
      yield serializers.serialize(
        object.k,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.silhouette != null) {
      yield r'silhouette';
      yield serializers.serialize(
        object.silhouette,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'features';
    yield serializers.serialize(
      object.features,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'segments';
    yield serializers.serialize(
      object.segments,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardSegment)]),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersProductsSegmentsPointsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersProductsSegments object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersProductsSegmentsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersProductsSegmentsStateEnum),
          ) as VendorDashboardOrdersProductsSegmentsStateEnum;
          result.state = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'k':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.k = valueDes;
          break;
        case r'silhouette':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.silhouette = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.features.replace(valueDes);
          break;
        case r'segments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardSegment)]),
          ) as BuiltList<VendorDashboardSegment>;
          result.segments.replace(valueDes);
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersProductsSegmentsPointsInner)]),
          ) as BuiltList<VendorDashboardOrdersProductsSegmentsPointsInner>;
          result.points.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersProductsSegments deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersProductsSegmentsBuilder();
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


class VendorDashboardOrdersProductsSegmentsStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const VendorDashboardOrdersProductsSegmentsStateEnum OK = _$vendorDashboardOrdersProductsSegmentsStateEnum_OK;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_DATA')
  static const VendorDashboardOrdersProductsSegmentsStateEnum INSUFFICIENT_DATA = _$vendorDashboardOrdersProductsSegmentsStateEnum_INSUFFICIENT_DATA;

  static Serializer<VendorDashboardOrdersProductsSegmentsStateEnum> get serializer => _$vendorDashboardOrdersProductsSegmentsStateEnumSerializer;

  const VendorDashboardOrdersProductsSegmentsStateEnum._(String name): super(name);

  static BuiltSet<VendorDashboardOrdersProductsSegmentsStateEnum> get values => _$vendorDashboardOrdersProductsSegmentsStateEnumValues;
  static VendorDashboardOrdersProductsSegmentsStateEnum valueOf(String name) => _$vendorDashboardOrdersProductsSegmentsStateEnumValueOf(name);
}

