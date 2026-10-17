//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/tax_package.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_tax_packages200_response.g.dart';

/// ListTaxPackages200Response
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class ListTaxPackages200Response implements Built<ListTaxPackages200Response, ListTaxPackages200ResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<TaxPackage> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  ListTaxPackages200Response._();

  factory ListTaxPackages200Response([void updates(ListTaxPackages200ResponseBuilder b)]) = _$ListTaxPackages200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListTaxPackages200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListTaxPackages200Response> get serializer => _$ListTaxPackages200ResponseSerializer();
}

class _$ListTaxPackages200ResponseSerializer implements PrimitiveSerializer<ListTaxPackages200Response> {
  @override
  final Iterable<Type> types = const [ListTaxPackages200Response, _$ListTaxPackages200Response];

  @override
  final String wireName = r'ListTaxPackages200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListTaxPackages200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(TaxPackage)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListTaxPackages200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListTaxPackages200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TaxPackage)]),
          ) as BuiltList<TaxPackage>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListTaxPackages200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListTaxPackages200ResponseBuilder();
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


