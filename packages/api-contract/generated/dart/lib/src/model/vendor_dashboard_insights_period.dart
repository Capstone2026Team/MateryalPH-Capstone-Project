//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_insights_period.g.dart';

/// VendorDashboardInsightsPeriod
///
/// Properties:
/// * [days]
/// * [from]
/// * [to]
/// * [timezone]
@BuiltValue()
abstract class VendorDashboardInsightsPeriod implements Built<VendorDashboardInsightsPeriod, VendorDashboardInsightsPeriodBuilder> {
  @BuiltValueField(wireName: r'days')
  int get days;

  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  VendorDashboardInsightsPeriod._();

  factory VendorDashboardInsightsPeriod([void updates(VendorDashboardInsightsPeriodBuilder b)]) = _$VendorDashboardInsightsPeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardInsightsPeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardInsightsPeriod> get serializer => _$VendorDashboardInsightsPeriodSerializer();
}

class _$VendorDashboardInsightsPeriodSerializer implements PrimitiveSerializer<VendorDashboardInsightsPeriod> {
  @override
  final Iterable<Type> types = const [VendorDashboardInsightsPeriod, _$VendorDashboardInsightsPeriod];

  @override
  final String wireName = r'VendorDashboardInsightsPeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardInsightsPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(int),
    );
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
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardInsightsPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardInsightsPeriodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.days = valueDes;
          break;
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
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardInsightsPeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardInsightsPeriodBuilder();
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


