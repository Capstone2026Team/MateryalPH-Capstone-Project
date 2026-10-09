//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_kpis_period.g.dart';

/// FinanceKpisPeriod
///
/// Properties:
/// * [from]
/// * [to]
@BuiltValue()
abstract class FinanceKpisPeriod implements Built<FinanceKpisPeriod, FinanceKpisPeriodBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  FinanceKpisPeriod._();

  factory FinanceKpisPeriod([void updates(FinanceKpisPeriodBuilder b)]) = _$FinanceKpisPeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceKpisPeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceKpisPeriod> get serializer => _$FinanceKpisPeriodSerializer();
}

class _$FinanceKpisPeriodSerializer implements PrimitiveSerializer<FinanceKpisPeriod> {
  @override
  final Iterable<Type> types = const [FinanceKpisPeriod, _$FinanceKpisPeriod];

  @override
  final String wireName = r'FinanceKpisPeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceKpisPeriod object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceKpisPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceKpisPeriodBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceKpisPeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceKpisPeriodBuilder();
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


