//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stock_confirmation_schedule.g.dart';

/// Stale-stock schedule. Exact UTC instants; clients render them in Asia/Manila beside the countdown.
///
/// Properties:
/// * [state]
/// * [confirmedAt]
/// * [firstReminderAt] - Day 7.
/// * [finalReminderAt] - Day 12.
/// * [hideAt] - Day 15.
/// * [daysSinceConfirmation]
@BuiltValue()
abstract class StockConfirmationSchedule implements Built<StockConfirmationSchedule, StockConfirmationScheduleBuilder> {
  @BuiltValueField(wireName: r'state')
  StockConfirmationScheduleStateEnum get state;
  // enum stateEnum {  CONFIRMED,  REMINDER,  FINAL_REMINDER,  OVERDUE,  NOT_CONFIRMED,  };

  @BuiltValueField(wireName: r'confirmed_at')
  DateTime? get confirmedAt;

  /// Day 7.
  @BuiltValueField(wireName: r'first_reminder_at')
  DateTime? get firstReminderAt;

  /// Day 12.
  @BuiltValueField(wireName: r'final_reminder_at')
  DateTime? get finalReminderAt;

  /// Day 15.
  @BuiltValueField(wireName: r'hide_at')
  DateTime? get hideAt;

  @BuiltValueField(wireName: r'days_since_confirmation')
  int? get daysSinceConfirmation;

  StockConfirmationSchedule._();

  factory StockConfirmationSchedule([void updates(StockConfirmationScheduleBuilder b)]) = _$StockConfirmationSchedule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StockConfirmationScheduleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StockConfirmationSchedule> get serializer => _$StockConfirmationScheduleSerializer();
}

class _$StockConfirmationScheduleSerializer implements PrimitiveSerializer<StockConfirmationSchedule> {
  @override
  final Iterable<Type> types = const [StockConfirmationSchedule, _$StockConfirmationSchedule];

  @override
  final String wireName = r'StockConfirmationSchedule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StockConfirmationSchedule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(StockConfirmationScheduleStateEnum),
    );
    yield r'confirmed_at';
    yield object.confirmedAt == null ? null : serializers.serialize(
      object.confirmedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'first_reminder_at';
    yield object.firstReminderAt == null ? null : serializers.serialize(
      object.firstReminderAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'final_reminder_at';
    yield object.finalReminderAt == null ? null : serializers.serialize(
      object.finalReminderAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'hide_at';
    yield object.hideAt == null ? null : serializers.serialize(
      object.hideAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'days_since_confirmation';
    yield object.daysSinceConfirmation == null ? null : serializers.serialize(
      object.daysSinceConfirmation,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StockConfirmationSchedule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StockConfirmationScheduleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StockConfirmationScheduleStateEnum),
          ) as StockConfirmationScheduleStateEnum;
          result.state = valueDes;
          break;
        case r'confirmed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.confirmedAt = valueDes;
          break;
        case r'first_reminder_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.firstReminderAt = valueDes;
          break;
        case r'final_reminder_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.finalReminderAt = valueDes;
          break;
        case r'hide_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.hideAt = valueDes;
          break;
        case r'days_since_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.daysSinceConfirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StockConfirmationSchedule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StockConfirmationScheduleBuilder();
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


class StockConfirmationScheduleStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const StockConfirmationScheduleStateEnum CONFIRMED = _$stockConfirmationScheduleStateEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'REMINDER')
  static const StockConfirmationScheduleStateEnum REMINDER = _$stockConfirmationScheduleStateEnum_REMINDER;
  @BuiltValueEnumConst(wireName: r'FINAL_REMINDER')
  static const StockConfirmationScheduleStateEnum FINAL_REMINDER = _$stockConfirmationScheduleStateEnum_FINAL_REMINDER;
  @BuiltValueEnumConst(wireName: r'OVERDUE')
  static const StockConfirmationScheduleStateEnum OVERDUE = _$stockConfirmationScheduleStateEnum_OVERDUE;
  @BuiltValueEnumConst(wireName: r'NOT_CONFIRMED')
  static const StockConfirmationScheduleStateEnum NOT_CONFIRMED = _$stockConfirmationScheduleStateEnum_NOT_CONFIRMED;

  static Serializer<StockConfirmationScheduleStateEnum> get serializer => _$stockConfirmationScheduleStateEnumSerializer;

  const StockConfirmationScheduleStateEnum._(String name): super(name);

  static BuiltSet<StockConfirmationScheduleStateEnum> get values => _$stockConfirmationScheduleStateEnumValues;
  static StockConfirmationScheduleStateEnum valueOf(String name) => _$stockConfirmationScheduleStateEnumValueOf(name);
}

