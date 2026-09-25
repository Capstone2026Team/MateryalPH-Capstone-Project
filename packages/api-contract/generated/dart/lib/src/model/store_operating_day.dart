//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'store_operating_day.g.dart';

/// StoreOperatingDay
///
/// Properties:
/// * [dayOfWeek] - ISO weekday; Monday is 1 and Sunday is 7.
/// * [status]
/// * [opensAt] - Philippine local time; null when Closed.
/// * [closesAt] - Later than opens_at on the same day; overnight periods are unsupported.
@BuiltValue()
abstract class StoreOperatingDay implements Built<StoreOperatingDay, StoreOperatingDayBuilder> {
  /// ISO weekday; Monday is 1 and Sunday is 7.
  @BuiltValueField(wireName: r'day_of_week')
  int get dayOfWeek;

  @BuiltValueField(wireName: r'status')
  StoreOperatingDayStatusEnum get status;
  // enum statusEnum {  OPEN,  CLOSED,  };

  /// Philippine local time; null when Closed.
  @BuiltValueField(wireName: r'opens_at')
  String? get opensAt;

  /// Later than opens_at on the same day; overnight periods are unsupported.
  @BuiltValueField(wireName: r'closes_at')
  String? get closesAt;

  StoreOperatingDay._();

  factory StoreOperatingDay([void updates(StoreOperatingDayBuilder b)]) = _$StoreOperatingDay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StoreOperatingDayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StoreOperatingDay> get serializer => _$StoreOperatingDaySerializer();
}

class _$StoreOperatingDaySerializer implements PrimitiveSerializer<StoreOperatingDay> {
  @override
  final Iterable<Type> types = const [StoreOperatingDay, _$StoreOperatingDay];

  @override
  final String wireName = r'StoreOperatingDay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StoreOperatingDay object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'day_of_week';
    yield serializers.serialize(
      object.dayOfWeek,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StoreOperatingDayStatusEnum),
    );
    if (object.opensAt != null) {
      yield r'opens_at';
      yield serializers.serialize(
        object.opensAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.closesAt != null) {
      yield r'closes_at';
      yield serializers.serialize(
        object.closesAt,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StoreOperatingDay object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StoreOperatingDayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'day_of_week':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dayOfWeek = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoreOperatingDayStatusEnum),
          ) as StoreOperatingDayStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StoreOperatingDay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StoreOperatingDayBuilder();
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


class StoreOperatingDayStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const StoreOperatingDayStatusEnum OPEN = _$storeOperatingDayStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const StoreOperatingDayStatusEnum CLOSED = _$storeOperatingDayStatusEnum_CLOSED;

  static Serializer<StoreOperatingDayStatusEnum> get serializer => _$storeOperatingDayStatusEnumSerializer;

  const StoreOperatingDayStatusEnum._(String name): super(name);

  static BuiltSet<StoreOperatingDayStatusEnum> get values => _$storeOperatingDayStatusEnumValues;
  static StoreOperatingDayStatusEnum valueOf(String name) => _$storeOperatingDayStatusEnumValueOf(name);
}

