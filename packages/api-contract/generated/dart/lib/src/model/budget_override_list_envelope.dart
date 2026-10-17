//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/budget_override_record.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'budget_override_list_envelope.g.dart';

/// BudgetOverrideListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class BudgetOverrideListEnvelope implements Built<BudgetOverrideListEnvelope, BudgetOverrideListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<BudgetOverrideRecord> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  BudgetOverrideListEnvelope._();

  factory BudgetOverrideListEnvelope([void updates(BudgetOverrideListEnvelopeBuilder b)]) = _$BudgetOverrideListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BudgetOverrideListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BudgetOverrideListEnvelope> get serializer => _$BudgetOverrideListEnvelopeSerializer();
}

class _$BudgetOverrideListEnvelopeSerializer implements PrimitiveSerializer<BudgetOverrideListEnvelope> {
  @override
  final Iterable<Type> types = const [BudgetOverrideListEnvelope, _$BudgetOverrideListEnvelope];

  @override
  final String wireName = r'BudgetOverrideListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BudgetOverrideListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(BudgetOverrideRecord)]),
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
    BudgetOverrideListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BudgetOverrideListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BudgetOverrideRecord)]),
          ) as BuiltList<BudgetOverrideRecord>;
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
  BudgetOverrideListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BudgetOverrideListEnvelopeBuilder();
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


