//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_dashboard_disclosure.g.dart';

/// GeoDashboardDisclosure
///
/// Properties:
/// * [minimumPersons]
/// * [method]
/// * [description]
@BuiltValue()
abstract class GeoDashboardDisclosure implements Built<GeoDashboardDisclosure, GeoDashboardDisclosureBuilder> {
  @BuiltValueField(wireName: r'minimum_persons')
  int get minimumPersons;

  @BuiltValueField(wireName: r'method')
  GeoDashboardDisclosureMethodEnum get method;
  // enum methodEnum {  ROLL_UP_TO_PARENT,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  GeoDashboardDisclosure._();

  factory GeoDashboardDisclosure([void updates(GeoDashboardDisclosureBuilder b)]) = _$GeoDashboardDisclosure;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDashboardDisclosureBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDashboardDisclosure> get serializer => _$GeoDashboardDisclosureSerializer();
}

class _$GeoDashboardDisclosureSerializer implements PrimitiveSerializer<GeoDashboardDisclosure> {
  @override
  final Iterable<Type> types = const [GeoDashboardDisclosure, _$GeoDashboardDisclosure];

  @override
  final String wireName = r'GeoDashboardDisclosure';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDashboardDisclosure object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minimum_persons';
    yield serializers.serialize(
      object.minimumPersons,
      specifiedType: const FullType(int),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(GeoDashboardDisclosureMethodEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDashboardDisclosure object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDashboardDisclosureBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minimum_persons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minimumPersons = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDashboardDisclosureMethodEnum),
          ) as GeoDashboardDisclosureMethodEnum;
          result.method = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDashboardDisclosure deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDashboardDisclosureBuilder();
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


class GeoDashboardDisclosureMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ROLL_UP_TO_PARENT')
  static const GeoDashboardDisclosureMethodEnum ROLL_UP_TO_PARENT = _$geoDashboardDisclosureMethodEnum_ROLL_UP_TO_PARENT;

  static Serializer<GeoDashboardDisclosureMethodEnum> get serializer => _$geoDashboardDisclosureMethodEnumSerializer;

  const GeoDashboardDisclosureMethodEnum._(String name): super(name);

  static BuiltSet<GeoDashboardDisclosureMethodEnum> get values => _$geoDashboardDisclosureMethodEnumValues;
  static GeoDashboardDisclosureMethodEnum valueOf(String name) => _$geoDashboardDisclosureMethodEnumValueOf(name);
}

