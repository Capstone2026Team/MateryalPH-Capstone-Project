//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'quotation_location_search.g.dart';

/// Supply exactly one selection - query for address search, latitude plus longitude for a map pin, or address_id to reopen a location previously proposed in this same conversation. Device GPS and the Buyer address book are never queried.
///
/// Properties:
/// * [query]
/// * [latitude]
/// * [longitude]
/// * [addressId]
@BuiltValue()
abstract class QuotationLocationSearch implements Built<QuotationLocationSearch, QuotationLocationSearchBuilder> {
  @BuiltValueField(wireName: r'query')
  String? get query;

  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  @BuiltValueField(wireName: r'address_id')
  String? get addressId;

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
    if (object.query != null) {
      yield r'query';
      yield serializers.serialize(
        object.query,
        specifiedType: const FullType(String),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.addressId != null) {
      yield r'address_id';
      yield serializers.serialize(
        object.addressId,
        specifiedType: const FullType(String),
      );
    }
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.query = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'address_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.addressId = valueDes;
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


