//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'quotation_location_search.g.dart';

/// QuotationLocationSearch
///
/// Properties:
/// * [query]
@BuiltValue()
abstract class QuotationLocationSearch implements Built<QuotationLocationSearch, QuotationLocationSearchBuilder> {
  @BuiltValueField(wireName: r'query')
  String get query;

  QuotationLocationSearch._();

  factory QuotationLocationSearch([void updates(QuotationLocationSearchBuilder b)]) = _$QuotationLocationSearch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QuotationLocationSearchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QuotationLocationSearch> get serializer => _$QuotationLocationSearchSerializer();
}

class _$QuotationLocationSearchSerializer implements PrimitiveSerializer<QuotationLocationSearch> {
  @override
  final Iterable<Type> types = const [QuotationLocationSearch, _$QuotationLocationSearch];

  @override
  final String wireName = r'QuotationLocationSearch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QuotationLocationSearch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'query';
    yield serializers.serialize(
      object.query,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QuotationLocationSearch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QuotationLocationSearchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.query = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QuotationLocationSearch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QuotationLocationSearchBuilder();
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


