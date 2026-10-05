//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_current_counts.g.dart';

/// AnalyticsCurrentCounts
///
/// Properties:
/// * [vendorCount]
/// * [listingCount]
/// * [status]
@BuiltValue()
abstract class AnalyticsCurrentCounts implements Built<AnalyticsCurrentCounts, AnalyticsCurrentCountsBuilder> {
  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'listing_count')
  int get listingCount;

  @BuiltValueField(wireName: r'status')
  AnalyticsCurrentCountsStatusEnum get status;
  // enum statusEnum {  AVAILABLE,  NO_CURRENT_OFFERS,  };

  AnalyticsCurrentCounts._();

  factory AnalyticsCurrentCounts([void updates(AnalyticsCurrentCountsBuilder b)]) = _$AnalyticsCurrentCounts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsCurrentCountsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsCurrentCounts> get serializer => _$AnalyticsCurrentCountsSerializer();
}

class _$AnalyticsCurrentCountsSerializer implements PrimitiveSerializer<AnalyticsCurrentCounts> {
  @override
  final Iterable<Type> types = const [AnalyticsCurrentCounts, _$AnalyticsCurrentCounts];

  @override
  final String wireName = r'AnalyticsCurrentCounts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsCurrentCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'listing_count';
    yield serializers.serialize(
      object.listingCount,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AnalyticsCurrentCountsStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsCurrentCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsCurrentCountsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'listing_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listingCount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCurrentCountsStatusEnum),
          ) as AnalyticsCurrentCountsStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsCurrentCounts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsCurrentCountsBuilder();
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


class AnalyticsCurrentCountsStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const AnalyticsCurrentCountsStatusEnum AVAILABLE = _$analyticsCurrentCountsStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'NO_CURRENT_OFFERS')
  static const AnalyticsCurrentCountsStatusEnum NO_CURRENT_OFFERS = _$analyticsCurrentCountsStatusEnum_NO_CURRENT_OFFERS;

  static Serializer<AnalyticsCurrentCountsStatusEnum> get serializer => _$analyticsCurrentCountsStatusEnumSerializer;

  const AnalyticsCurrentCountsStatusEnum._(String name): super(name);

  static BuiltSet<AnalyticsCurrentCountsStatusEnum> get values => _$analyticsCurrentCountsStatusEnumValues;
  static AnalyticsCurrentCountsStatusEnum valueOf(String name) => _$analyticsCurrentCountsStatusEnumValueOf(name);
}

