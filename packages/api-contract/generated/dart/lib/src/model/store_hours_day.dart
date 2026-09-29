//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'store_hours_day.g.dart';

/// StoreHoursDay
///
/// Properties:
/// * [date] - Asia/Manila calendar date.
/// * [dayOfWeek]
/// * [weekday]
/// * [status]
/// * [opensAt]
/// * [closesAt] - The closing minute itself is closed.
/// * [source_]
@BuiltValue()
abstract class StoreHoursDay implements Built<StoreHoursDay, StoreHoursDayBuilder> {
  /// Asia/Manila calendar date.
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'day_of_week')
  int get dayOfWeek;

  @BuiltValueField(wireName: r'weekday')
  String get weekday;

  @BuiltValueField(wireName: r'status')
  StoreHoursDayStatusEnum get status;
  // enum statusEnum {  OPEN,  CLOSED,  };

  @BuiltValueField(wireName: r'opens_at')
  String? get opensAt;

  /// The closing minute itself is closed.
  @BuiltValueField(wireName: r'closes_at')
  String? get closesAt;

  @BuiltValueField(wireName: r'source')
  StoreHoursDaySource_Enum get source_;
  // enum source_Enum {  WEEKLY,  DATE_OVERRIDE,  };

  StoreHoursDay._();

  factory StoreHoursDay([void updates(StoreHoursDayBuilder b)]) = _$StoreHoursDay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StoreHoursDayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StoreHoursDay> get serializer => _$StoreHoursDaySerializer();
}

class _$StoreHoursDaySerializer implements PrimitiveSerializer<StoreHoursDay> {
  @override
  final Iterable<Type> types = const [StoreHoursDay, _$StoreHoursDay];

  @override
  final String wireName = r'StoreHoursDay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StoreHoursDay object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'day_of_week';
    yield serializers.serialize(
      object.dayOfWeek,
      specifiedType: const FullType(int),
    );
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StoreHoursDayStatusEnum),
    );
    yield r'opens_at';
    yield object.opensAt == null ? null : serializers.serialize(
      object.opensAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'closes_at';
    yield object.closesAt == null ? null : serializers.serialize(
      object.closesAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(StoreHoursDaySource_Enum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StoreHoursDay object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StoreHoursDayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'day_of_week':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dayOfWeek = valueDes;
          break;
        case r'weekday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.weekday = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoreHoursDayStatusEnum),
          ) as StoreHoursDayStatusEnum;
          result.status = valueDes;
          break;
        case r'opens_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'closes_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoreHoursDaySource_Enum),
          ) as StoreHoursDaySource_Enum;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StoreHoursDay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StoreHoursDayBuilder();
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


class StoreHoursDayStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const StoreHoursDayStatusEnum OPEN = _$storeHoursDayStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const StoreHoursDayStatusEnum CLOSED = _$storeHoursDayStatusEnum_CLOSED;

  static Serializer<StoreHoursDayStatusEnum> get serializer => _$storeHoursDayStatusEnumSerializer;

  const StoreHoursDayStatusEnum._(String name): super(name);

  static BuiltSet<StoreHoursDayStatusEnum> get values => _$storeHoursDayStatusEnumValues;
  static StoreHoursDayStatusEnum valueOf(String name) => _$storeHoursDayStatusEnumValueOf(name);
}

class StoreHoursDaySource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WEEKLY')
  static const StoreHoursDaySource_Enum WEEKLY = _$storeHoursDaySourceEnum_WEEKLY;
  @BuiltValueEnumConst(wireName: r'DATE_OVERRIDE')
  static const StoreHoursDaySource_Enum DATE_OVERRIDE = _$storeHoursDaySourceEnum_DATE_OVERRIDE;

  static Serializer<StoreHoursDaySource_Enum> get serializer => _$storeHoursDaySourceEnumSerializer;

  const StoreHoursDaySource_Enum._(String name): super(name);

  static BuiltSet<StoreHoursDaySource_Enum> get values => _$storeHoursDaySourceEnumValues;
  static StoreHoursDaySource_Enum valueOf(String name) => _$storeHoursDaySourceEnumValueOf(name);
}

