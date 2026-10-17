//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/marking_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_lookup_request.g.dart';

/// ComplianceLookupRequest
///
/// Properties:
/// * [markingType]
/// * [number]
@BuiltValue()
abstract class ComplianceLookupRequest implements Built<ComplianceLookupRequest, ComplianceLookupRequestBuilder> {
  @BuiltValueField(wireName: r'marking_type')
  MarkingType get markingType;
  // enum markingTypeEnum {  PS_MARK,  ICC_STICKER,  };

  @BuiltValueField(wireName: r'number')
  String get number;

  ComplianceLookupRequest._();

  factory ComplianceLookupRequest([void updates(ComplianceLookupRequestBuilder b)]) = _$ComplianceLookupRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceLookupRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceLookupRequest> get serializer => _$ComplianceLookupRequestSerializer();
}

class _$ComplianceLookupRequestSerializer implements PrimitiveSerializer<ComplianceLookupRequest> {
  @override
  final Iterable<Type> types = const [ComplianceLookupRequest, _$ComplianceLookupRequest];

  @override
  final String wireName = r'ComplianceLookupRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceLookupRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'marking_type';
    yield serializers.serialize(
      object.markingType,
      specifiedType: const FullType(MarkingType),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceLookupRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceLookupRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'marking_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MarkingType),
          ) as MarkingType;
          result.markingType = valueDes;
          break;
        case r'number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.number = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceLookupRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceLookupRequestBuilder();
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


