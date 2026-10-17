//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/vendor_navigation_updates.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_vendor_navigation_updates200_response.g.dart';

/// GetVendorNavigationUpdates200Response
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class GetVendorNavigationUpdates200Response implements Built<GetVendorNavigationUpdates200Response, GetVendorNavigationUpdates200ResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  VendorNavigationUpdates get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  GetVendorNavigationUpdates200Response._();

  factory GetVendorNavigationUpdates200Response([void updates(GetVendorNavigationUpdates200ResponseBuilder b)]) = _$GetVendorNavigationUpdates200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetVendorNavigationUpdates200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetVendorNavigationUpdates200Response> get serializer => _$GetVendorNavigationUpdates200ResponseSerializer();
}

class _$GetVendorNavigationUpdates200ResponseSerializer implements PrimitiveSerializer<GetVendorNavigationUpdates200Response> {
  @override
  final Iterable<Type> types = const [GetVendorNavigationUpdates200Response, _$GetVendorNavigationUpdates200Response];

  @override
  final String wireName = r'GetVendorNavigationUpdates200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetVendorNavigationUpdates200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(VendorNavigationUpdates),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetVendorNavigationUpdates200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetVendorNavigationUpdates200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorNavigationUpdates),
          ) as VendorNavigationUpdates;
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
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
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
  GetVendorNavigationUpdates200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetVendorNavigationUpdates200ResponseBuilder();
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


