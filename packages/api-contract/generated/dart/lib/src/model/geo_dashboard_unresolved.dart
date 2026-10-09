//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_dashboard_unresolved.g.dart';

/// GeoDashboardUnresolved
///
/// Properties:
/// * [orders]
/// * [vendors]
/// * [registeredBuyers]
/// * [responses]
/// * [activity]
@BuiltValue()
abstract class GeoDashboardUnresolved implements Built<GeoDashboardUnresolved, GeoDashboardUnresolvedBuilder> {
  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'vendors')
  int get vendors;

  @BuiltValueField(wireName: r'registered_buyers')
  int get registeredBuyers;

  @BuiltValueField(wireName: r'responses')
  int get responses;

  @BuiltValueField(wireName: r'activity')
  int get activity;

  GeoDashboardUnresolved._();

  factory GeoDashboardUnresolved([void updates(GeoDashboardUnresolvedBuilder b)]) = _$GeoDashboardUnresolved;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDashboardUnresolvedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDashboardUnresolved> get serializer => _$GeoDashboardUnresolvedSerializer();
}

class _$GeoDashboardUnresolvedSerializer implements PrimitiveSerializer<GeoDashboardUnresolved> {
  @override
  final Iterable<Type> types = const [GeoDashboardUnresolved, _$GeoDashboardUnresolved];

  @override
  final String wireName = r'GeoDashboardUnresolved';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDashboardUnresolved object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'vendors';
    yield serializers.serialize(
      object.vendors,
      specifiedType: const FullType(int),
    );
    yield r'registered_buyers';
    yield serializers.serialize(
      object.registeredBuyers,
      specifiedType: const FullType(int),
    );
    yield r'responses';
    yield serializers.serialize(
      object.responses,
      specifiedType: const FullType(int),
    );
    yield r'activity';
    yield serializers.serialize(
      object.activity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDashboardUnresolved object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDashboardUnresolvedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendors = valueDes;
          break;
        case r'registered_buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.registeredBuyers = valueDes;
          break;
        case r'responses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.responses = valueDes;
          break;
        case r'activity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDashboardUnresolved deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDashboardUnresolvedBuilder();
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


