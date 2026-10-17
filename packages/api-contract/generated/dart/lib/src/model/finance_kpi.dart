//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_kpi.g.dart';

/// FinanceKpi
///
/// Properties:
/// * [key]
/// * [label]
/// * [valueCentavos]
/// * [definition]
@BuiltValue()
abstract class FinanceKpi implements Built<FinanceKpi, FinanceKpiBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'value_centavos')
  int get valueCentavos;

  @BuiltValueField(wireName: r'definition')
  String get definition;

  FinanceKpi._();

  factory FinanceKpi([void updates(FinanceKpiBuilder b)]) = _$FinanceKpi;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceKpiBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceKpi> get serializer => _$FinanceKpiSerializer();
}

class _$FinanceKpiSerializer implements PrimitiveSerializer<FinanceKpi> {
  @override
  final Iterable<Type> types = const [FinanceKpi, _$FinanceKpi];

  @override
  final String wireName = r'FinanceKpi';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceKpi object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'value_centavos';
    yield serializers.serialize(
      object.valueCentavos,
      specifiedType: const FullType(int),
    );
    yield r'definition';
    yield serializers.serialize(
      object.definition,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceKpi object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceKpiBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.valueCentavos = valueDes;
          break;
        case r'definition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.definition = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceKpi deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceKpiBuilder();
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


