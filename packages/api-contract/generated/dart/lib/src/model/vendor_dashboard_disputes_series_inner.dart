//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_disputes_series_inner.g.dart';

/// VendorDashboardDisputesSeriesInner
///
/// Properties:
/// * [date]
/// * [cases]
@BuiltValue()
abstract class VendorDashboardDisputesSeriesInner implements Built<VendorDashboardDisputesSeriesInner, VendorDashboardDisputesSeriesInnerBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'cases')
  int get cases;

  VendorDashboardDisputesSeriesInner._();

  factory VendorDashboardDisputesSeriesInner([void updates(VendorDashboardDisputesSeriesInnerBuilder b)]) = _$VendorDashboardDisputesSeriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardDisputesSeriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardDisputesSeriesInner> get serializer => _$VendorDashboardDisputesSeriesInnerSerializer();
}

class _$VendorDashboardDisputesSeriesInnerSerializer implements PrimitiveSerializer<VendorDashboardDisputesSeriesInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardDisputesSeriesInner, _$VendorDashboardDisputesSeriesInner];

  @override
  final String wireName = r'VendorDashboardDisputesSeriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardDisputesSeriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'cases';
    yield serializers.serialize(
      object.cases,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardDisputesSeriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardDisputesSeriesInnerBuilder result,
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
        case r'cases':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cases = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardDisputesSeriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardDisputesSeriesInnerBuilder();
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


