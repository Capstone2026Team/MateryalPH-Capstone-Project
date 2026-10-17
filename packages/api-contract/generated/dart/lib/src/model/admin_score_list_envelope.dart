//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/admin_score_row.dart';
import 'package:materyalph_api_client/src/model/review_list_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_score_list_envelope.g.dart';

/// AdminScoreListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class AdminScoreListEnvelope implements Built<AdminScoreListEnvelope, AdminScoreListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AdminScoreRow> get data;

  @BuiltValueField(wireName: r'meta')
  ReviewListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  AdminScoreListEnvelope._();

  factory AdminScoreListEnvelope([void updates(AdminScoreListEnvelopeBuilder b)]) = _$AdminScoreListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminScoreListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminScoreListEnvelope> get serializer => _$AdminScoreListEnvelopeSerializer();
}

class _$AdminScoreListEnvelopeSerializer implements PrimitiveSerializer<AdminScoreListEnvelope> {
  @override
  final Iterable<Type> types = const [AdminScoreListEnvelope, _$AdminScoreListEnvelope];

  @override
  final String wireName = r'AdminScoreListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminScoreListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AdminScoreRow)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(ReviewListMeta),
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
    AdminScoreListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminScoreListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminScoreRow)]),
          ) as BuiltList<AdminScoreRow>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewListMeta),
          ) as ReviewListMeta;
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
  AdminScoreListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminScoreListEnvelopeBuilder();
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


