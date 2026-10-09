//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_filter_applicability.g.dart';

/// GeoFilterApplicability
///
/// Properties:
/// * [filter]
/// * [appliesTo]
/// * [notApplicableTo]
/// * [note]
@BuiltValue()
abstract class GeoFilterApplicability implements Built<GeoFilterApplicability, GeoFilterApplicabilityBuilder> {
  @BuiltValueField(wireName: r'filter')
  String get filter;

  @BuiltValueField(wireName: r'applies_to')
  BuiltList<String> get appliesTo;

  @BuiltValueField(wireName: r'not_applicable_to')
  BuiltList<String> get notApplicableTo;

  @BuiltValueField(wireName: r'note')
  String get note;

  GeoFilterApplicability._();

  factory GeoFilterApplicability([void updates(GeoFilterApplicabilityBuilder b)]) = _$GeoFilterApplicability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoFilterApplicabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoFilterApplicability> get serializer => _$GeoFilterApplicabilitySerializer();
}

class _$GeoFilterApplicabilitySerializer implements PrimitiveSerializer<GeoFilterApplicability> {
  @override
  final Iterable<Type> types = const [GeoFilterApplicability, _$GeoFilterApplicability];

  @override
  final String wireName = r'GeoFilterApplicability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoFilterApplicability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'filter';
    yield serializers.serialize(
      object.filter,
      specifiedType: const FullType(String),
    );
    yield r'applies_to';
    yield serializers.serialize(
      object.appliesTo,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'not_applicable_to';
    yield serializers.serialize(
      object.notApplicableTo,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoFilterApplicability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoFilterApplicabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'filter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filter = valueDes;
          break;
        case r'applies_to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.appliesTo.replace(valueDes);
          break;
        case r'not_applicable_to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.notApplicableTo.replace(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoFilterApplicability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoFilterApplicabilityBuilder();
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


