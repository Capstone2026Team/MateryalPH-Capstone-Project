//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_dashboard_period.g.dart';

/// GeoDashboardPeriod
///
/// Properties:
/// * [from]
/// * [to]
/// * [granularity]
@BuiltValue()
abstract class GeoDashboardPeriod implements Built<GeoDashboardPeriod, GeoDashboardPeriodBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'granularity')
  GeoDashboardPeriodGranularityEnum get granularity;
  // enum granularityEnum {  DAY,  WEEK,  MONTH,  };

  GeoDashboardPeriod._();

  factory GeoDashboardPeriod([void updates(GeoDashboardPeriodBuilder b)]) = _$GeoDashboardPeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDashboardPeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDashboardPeriod> get serializer => _$GeoDashboardPeriodSerializer();
}

class _$GeoDashboardPeriodSerializer implements PrimitiveSerializer<GeoDashboardPeriod> {
  @override
  final Iterable<Type> types = const [GeoDashboardPeriod, _$GeoDashboardPeriod];

  @override
  final String wireName = r'GeoDashboardPeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDashboardPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(Date),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(Date),
    );
    yield r'granularity';
    yield serializers.serialize(
      object.granularity,
      specifiedType: const FullType(GeoDashboardPeriodGranularityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDashboardPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDashboardPeriodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.to = valueDes;
          break;
        case r'granularity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDashboardPeriodGranularityEnum),
          ) as GeoDashboardPeriodGranularityEnum;
          result.granularity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDashboardPeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDashboardPeriodBuilder();
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


class GeoDashboardPeriodGranularityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DAY')
  static const GeoDashboardPeriodGranularityEnum DAY = _$geoDashboardPeriodGranularityEnum_DAY;
  @BuiltValueEnumConst(wireName: r'WEEK')
  static const GeoDashboardPeriodGranularityEnum WEEK = _$geoDashboardPeriodGranularityEnum_WEEK;
  @BuiltValueEnumConst(wireName: r'MONTH')
  static const GeoDashboardPeriodGranularityEnum MONTH = _$geoDashboardPeriodGranularityEnum_MONTH;

  static Serializer<GeoDashboardPeriodGranularityEnum> get serializer => _$geoDashboardPeriodGranularityEnumSerializer;

  const GeoDashboardPeriodGranularityEnum._(String name): super(name);

  static BuiltSet<GeoDashboardPeriodGranularityEnum> get values => _$geoDashboardPeriodGranularityEnumValues;
  static GeoDashboardPeriodGranularityEnum valueOf(String name) => _$geoDashboardPeriodGranularityEnumValueOf(name);
}

