//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_trend_figures.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_trend_change.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_trend_comparison.g.dart';

/// VendorEarningsTrendComparison
///
/// Properties:
/// * [from]
/// * [to]
/// * [totals]
/// * [changePercent]
@BuiltValue()
abstract class VendorEarningsTrendComparison implements Built<VendorEarningsTrendComparison, VendorEarningsTrendComparisonBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'totals')
  VendorEarningsTrendFigures get totals;

  @BuiltValueField(wireName: r'change_percent')
  VendorEarningsTrendChange get changePercent;

  VendorEarningsTrendComparison._();

  factory VendorEarningsTrendComparison([void updates(VendorEarningsTrendComparisonBuilder b)]) = _$VendorEarningsTrendComparison;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsTrendComparisonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsTrendComparison> get serializer => _$VendorEarningsTrendComparisonSerializer();
}

class _$VendorEarningsTrendComparisonSerializer implements PrimitiveSerializer<VendorEarningsTrendComparison> {
  @override
  final Iterable<Type> types = const [VendorEarningsTrendComparison, _$VendorEarningsTrendComparison];

  @override
  final String wireName = r'VendorEarningsTrendComparison';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsTrendComparison object, {
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
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(VendorEarningsTrendFigures),
    );
    yield r'change_percent';
    yield serializers.serialize(
      object.changePercent,
      specifiedType: const FullType(VendorEarningsTrendChange),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsTrendComparison object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsTrendComparisonBuilder result,
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
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsTrendFigures),
          ) as VendorEarningsTrendFigures;
          result.totals.replace(valueDes);
          break;
        case r'change_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsTrendChange),
          ) as VendorEarningsTrendChange;
          result.changePercent.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsTrendComparison deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsTrendComparisonBuilder();
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


