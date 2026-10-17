//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_created_response_data.g.dart';

/// SiteInspectionCreatedResponseData
///
/// Properties:
/// * [id]
/// * [conversationId]
@BuiltValue()
abstract class SiteInspectionCreatedResponseData implements Built<SiteInspectionCreatedResponseData, SiteInspectionCreatedResponseDataBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'conversation_id')
  String get conversationId;

  SiteInspectionCreatedResponseData._();

  factory SiteInspectionCreatedResponseData([void updates(SiteInspectionCreatedResponseDataBuilder b)]) = _$SiteInspectionCreatedResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionCreatedResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionCreatedResponseData> get serializer => _$SiteInspectionCreatedResponseDataSerializer();
}

class _$SiteInspectionCreatedResponseDataSerializer implements PrimitiveSerializer<SiteInspectionCreatedResponseData> {
  @override
  final Iterable<Type> types = const [SiteInspectionCreatedResponseData, _$SiteInspectionCreatedResponseData];

  @override
  final String wireName = r'SiteInspectionCreatedResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionCreatedResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'conversation_id';
    yield serializers.serialize(
      object.conversationId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionCreatedResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionCreatedResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'conversation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.conversationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionCreatedResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionCreatedResponseDataBuilder();
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


