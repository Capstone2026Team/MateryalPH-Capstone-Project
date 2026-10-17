//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_marketplace_period.g.dart';

/// AdminDashboardMarketplacePeriod
///
/// Properties:
/// * [from]
/// * [to]
/// * [granularity]
/// * [days]
@BuiltValue()
abstract class AdminDashboardMarketplacePeriod implements Built<AdminDashboardMarketplacePeriod, AdminDashboardMarketplacePeriodBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'granularity')
  AdminDashboardMarketplacePeriodGranularityEnum get granularity;
  // enum granularityEnum {  DAY,  WEEK,  MONTH,  };

  @BuiltValueField(wireName: r'days')
  int get days;

  AdminDashboardMarketplacePeriod._();

  factory AdminDashboardMarketplacePeriod([void updates(AdminDashboardMarketplacePeriodBuilder b)]) = _$AdminDashboardMarketplacePeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardMarketplacePeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardMarketplacePeriod> get serializer => _$AdminDashboardMarketplacePeriodSerializer();
}

class _$AdminDashboardMarketplacePeriodSerializer implements PrimitiveSerializer<AdminDashboardMarketplacePeriod> {
  @override
  final Iterable<Type> types = const [AdminDashboardMarketplacePeriod, _$AdminDashboardMarketplacePeriod];

  @override
  final String wireName = r'AdminDashboardMarketplacePeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardMarketplacePeriod object, {
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
      specifiedType: const FullType(AdminDashboardMarketplacePeriodGranularityEnum),
    );
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardMarketplacePeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardMarketplacePeriodBuilder result,
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
            specifiedType: const FullType(AdminDashboardMarketplacePeriodGranularityEnum),
          ) as AdminDashboardMarketplacePeriodGranularityEnum;
          result.granularity = valueDes;
          break;
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.days = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardMarketplacePeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardMarketplacePeriodBuilder();
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


class AdminDashboardMarketplacePeriodGranularityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DAY')
  static const AdminDashboardMarketplacePeriodGranularityEnum DAY = _$adminDashboardMarketplacePeriodGranularityEnum_DAY;
  @BuiltValueEnumConst(wireName: r'WEEK')
  static const AdminDashboardMarketplacePeriodGranularityEnum WEEK = _$adminDashboardMarketplacePeriodGranularityEnum_WEEK;
  @BuiltValueEnumConst(wireName: r'MONTH')
  static const AdminDashboardMarketplacePeriodGranularityEnum MONTH = _$adminDashboardMarketplacePeriodGranularityEnum_MONTH;

  static Serializer<AdminDashboardMarketplacePeriodGranularityEnum> get serializer => _$adminDashboardMarketplacePeriodGranularityEnumSerializer;

  const AdminDashboardMarketplacePeriodGranularityEnum._(String name): super(name);

  static BuiltSet<AdminDashboardMarketplacePeriodGranularityEnum> get values => _$adminDashboardMarketplacePeriodGranularityEnumValues;
  static AdminDashboardMarketplacePeriodGranularityEnum valueOf(String name) => _$adminDashboardMarketplacePeriodGranularityEnumValueOf(name);
}

