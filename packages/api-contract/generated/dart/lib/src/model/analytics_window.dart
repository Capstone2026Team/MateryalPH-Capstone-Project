//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_window.g.dart';

/// AnalyticsWindow
///
/// Properties:
/// * [presetDays]
/// * [startDate]
/// * [endDate]
/// * [earliestAvailableDate]
/// * [latestAvailableDate]
/// * [maxDays]
/// * [presets]
@BuiltValue()
abstract class AnalyticsWindow implements Built<AnalyticsWindow, AnalyticsWindowBuilder> {
  @BuiltValueField(wireName: r'preset_days')
  int? get presetDays;

  @BuiltValueField(wireName: r'start_date')
  Date? get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date? get endDate;

  @BuiltValueField(wireName: r'earliest_available_date')
  Date? get earliestAvailableDate;

  @BuiltValueField(wireName: r'latest_available_date')
  Date? get latestAvailableDate;

  @BuiltValueField(wireName: r'max_days')
  int get maxDays;

  @BuiltValueField(wireName: r'presets')
  BuiltList<int> get presets;

  AnalyticsWindow._();

  factory AnalyticsWindow([void updates(AnalyticsWindowBuilder b)]) = _$AnalyticsWindow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsWindowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsWindow> get serializer => _$AnalyticsWindowSerializer();
}

class _$AnalyticsWindowSerializer implements PrimitiveSerializer<AnalyticsWindow> {
  @override
  final Iterable<Type> types = const [AnalyticsWindow, _$AnalyticsWindow];

  @override
  final String wireName = r'AnalyticsWindow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsWindow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.presetDays != null) {
      yield r'preset_days';
      yield serializers.serialize(
        object.presetDays,
        specifiedType: const FullType(int),
      );
    }
    if (object.startDate != null) {
      yield r'start_date';
      yield serializers.serialize(
        object.startDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.endDate != null) {
      yield r'end_date';
      yield serializers.serialize(
        object.endDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.earliestAvailableDate != null) {
      yield r'earliest_available_date';
      yield serializers.serialize(
        object.earliestAvailableDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.latestAvailableDate != null) {
      yield r'latest_available_date';
      yield serializers.serialize(
        object.latestAvailableDate,
        specifiedType: const FullType(Date),
      );
    }
    yield r'max_days';
    yield serializers.serialize(
      object.maxDays,
      specifiedType: const FullType(int),
    );
    yield r'presets';
    yield serializers.serialize(
      object.presets,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsWindow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsWindowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'preset_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.presetDays = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.startDate = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.endDate = valueDes;
          break;
        case r'earliest_available_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.earliestAvailableDate = valueDes;
          break;
        case r'latest_available_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.latestAvailableDate = valueDes;
          break;
        case r'max_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxDays = valueDes;
          break;
        case r'presets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.presets.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsWindow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsWindowBuilder();
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


