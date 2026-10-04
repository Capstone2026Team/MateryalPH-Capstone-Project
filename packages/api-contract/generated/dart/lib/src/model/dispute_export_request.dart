//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_export_request.g.dart';

/// DisputeExportRequest
///
/// Properties:
/// * [group]
@BuiltValue()
abstract class DisputeExportRequest implements Built<DisputeExportRequest, DisputeExportRequestBuilder> {
  @BuiltValueField(wireName: r'group')
  DisputeExportRequestGroupEnum? get group;
  // enum groupEnum {  ALL,  ACTIVE,  NEEDS_RESPONSE,  ADMIN_REVIEW,  DECIDED,  CONCLUDED,  };

  DisputeExportRequest._();

  factory DisputeExportRequest([void updates(DisputeExportRequestBuilder b)]) = _$DisputeExportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeExportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeExportRequest> get serializer => _$DisputeExportRequestSerializer();
}

class _$DisputeExportRequestSerializer implements PrimitiveSerializer<DisputeExportRequest> {
  @override
  final Iterable<Type> types = const [DisputeExportRequest, _$DisputeExportRequest];

  @override
  final String wireName = r'DisputeExportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeExportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.group != null) {
      yield r'group';
      yield serializers.serialize(
        object.group,
        specifiedType: const FullType(DisputeExportRequestGroupEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeExportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeExportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeExportRequestGroupEnum),
          ) as DisputeExportRequestGroupEnum?;
          if (valueDes == null) continue;
          result.group = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeExportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeExportRequestBuilder();
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


class DisputeExportRequestGroupEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ALL')
  static const DisputeExportRequestGroupEnum ALL = _$disputeExportRequestGroupEnum_ALL;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const DisputeExportRequestGroupEnum ACTIVE = _$disputeExportRequestGroupEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'NEEDS_RESPONSE')
  static const DisputeExportRequestGroupEnum NEEDS_RESPONSE = _$disputeExportRequestGroupEnum_NEEDS_RESPONSE;
  @BuiltValueEnumConst(wireName: r'ADMIN_REVIEW')
  static const DisputeExportRequestGroupEnum ADMIN_REVIEW = _$disputeExportRequestGroupEnum_ADMIN_REVIEW;
  @BuiltValueEnumConst(wireName: r'DECIDED')
  static const DisputeExportRequestGroupEnum DECIDED = _$disputeExportRequestGroupEnum_DECIDED;
  @BuiltValueEnumConst(wireName: r'CONCLUDED')
  static const DisputeExportRequestGroupEnum CONCLUDED = _$disputeExportRequestGroupEnum_CONCLUDED;

  static Serializer<DisputeExportRequestGroupEnum> get serializer => _$disputeExportRequestGroupEnumSerializer;

  const DisputeExportRequestGroupEnum._(String name): super(name);

  static BuiltSet<DisputeExportRequestGroupEnum> get values => _$disputeExportRequestGroupEnumValues;
  static DisputeExportRequestGroupEnum valueOf(String name) => _$disputeExportRequestGroupEnumValueOf(name);
}

