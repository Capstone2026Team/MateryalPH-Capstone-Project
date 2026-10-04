//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dispute_clarification_request.g.dart';

/// AdminDisputeClarificationRequest
///
/// Properties:
/// * [parties]
/// * [question]
@BuiltValue()
abstract class AdminDisputeClarificationRequest implements Built<AdminDisputeClarificationRequest, AdminDisputeClarificationRequestBuilder> {
  @BuiltValueField(wireName: r'parties')
  BuiltList<AdminDisputeClarificationRequestPartiesEnum> get parties;
  // enum partiesEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'question')
  String get question;

  AdminDisputeClarificationRequest._();

  factory AdminDisputeClarificationRequest([void updates(AdminDisputeClarificationRequestBuilder b)]) = _$AdminDisputeClarificationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDisputeClarificationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDisputeClarificationRequest> get serializer => _$AdminDisputeClarificationRequestSerializer();
}

class _$AdminDisputeClarificationRequestSerializer implements PrimitiveSerializer<AdminDisputeClarificationRequest> {
  @override
  final Iterable<Type> types = const [AdminDisputeClarificationRequest, _$AdminDisputeClarificationRequest];

  @override
  final String wireName = r'AdminDisputeClarificationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDisputeClarificationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'parties';
    yield serializers.serialize(
      object.parties,
      specifiedType: const FullType(BuiltList, [FullType(AdminDisputeClarificationRequestPartiesEnum)]),
    );
    yield r'question';
    yield serializers.serialize(
      object.question,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDisputeClarificationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDisputeClarificationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'parties':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDisputeClarificationRequestPartiesEnum)]),
          ) as BuiltList<AdminDisputeClarificationRequestPartiesEnum>;
          result.parties.replace(valueDes);
          break;
        case r'question':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.question = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDisputeClarificationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDisputeClarificationRequestBuilder();
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


class AdminDisputeClarificationRequestPartiesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const AdminDisputeClarificationRequestPartiesEnum BUYER = _$adminDisputeClarificationRequestPartiesEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const AdminDisputeClarificationRequestPartiesEnum VENDOR = _$adminDisputeClarificationRequestPartiesEnum_VENDOR;

  static Serializer<AdminDisputeClarificationRequestPartiesEnum> get serializer => _$adminDisputeClarificationRequestPartiesEnumSerializer;

  const AdminDisputeClarificationRequestPartiesEnum._(String name): super(name);

  static BuiltSet<AdminDisputeClarificationRequestPartiesEnum> get values => _$adminDisputeClarificationRequestPartiesEnumValues;
  static AdminDisputeClarificationRequestPartiesEnum valueOf(String name) => _$adminDisputeClarificationRequestPartiesEnumValueOf(name);
}

