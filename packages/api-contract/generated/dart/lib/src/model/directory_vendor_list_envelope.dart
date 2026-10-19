//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/directory_vendor_row.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/directory_page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_list_envelope.g.dart';

/// DirectoryVendorListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class DirectoryVendorListEnvelope implements Built<DirectoryVendorListEnvelope, DirectoryVendorListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DirectoryVendorRow> get data;

  @BuiltValueField(wireName: r'meta')
  DirectoryPageMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  DirectoryVendorListEnvelope._();

  factory DirectoryVendorListEnvelope([void updates(DirectoryVendorListEnvelopeBuilder b)]) = _$DirectoryVendorListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorListEnvelope> get serializer => _$DirectoryVendorListEnvelopeSerializer();
}

class _$DirectoryVendorListEnvelopeSerializer implements PrimitiveSerializer<DirectoryVendorListEnvelope> {
  @override
  final Iterable<Type> types = const [DirectoryVendorListEnvelope, _$DirectoryVendorListEnvelope];

  @override
  final String wireName = r'DirectoryVendorListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DirectoryVendorRow)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(DirectoryPageMeta),
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
    DirectoryVendorListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DirectoryVendorRow)]),
          ) as BuiltList<DirectoryVendorRow>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryPageMeta),
          ) as DirectoryPageMeta;
          result.meta = valueDes.toBuilder();
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
  DirectoryVendorListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorListEnvelopeBuilder();
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


