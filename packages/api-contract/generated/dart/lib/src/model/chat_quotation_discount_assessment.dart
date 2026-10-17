//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_discount_assessment.g.dart';

/// ChatQuotationDiscountAssessment
///
/// Properties:
/// * [scope]
/// * [percent]
/// * [basisCentavos]
/// * [deductionCentavos]
@BuiltValue()
abstract class ChatQuotationDiscountAssessment implements Built<ChatQuotationDiscountAssessment, ChatQuotationDiscountAssessmentBuilder> {
  @BuiltValueField(wireName: r'scope')
  ChatQuotationDiscountAssessmentScopeEnum get scope;
  // enum scopeEnum {  MATERIALS,  DELIVERY,  };

  @BuiltValueField(wireName: r'percent')
  String get percent;

  @BuiltValueField(wireName: r'basis_centavos')
  int get basisCentavos;

  @BuiltValueField(wireName: r'deduction_centavos')
  int get deductionCentavos;

  ChatQuotationDiscountAssessment._();

  factory ChatQuotationDiscountAssessment([void updates(ChatQuotationDiscountAssessmentBuilder b)]) = _$ChatQuotationDiscountAssessment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationDiscountAssessmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationDiscountAssessment> get serializer => _$ChatQuotationDiscountAssessmentSerializer();
}

class _$ChatQuotationDiscountAssessmentSerializer implements PrimitiveSerializer<ChatQuotationDiscountAssessment> {
  @override
  final Iterable<Type> types = const [ChatQuotationDiscountAssessment, _$ChatQuotationDiscountAssessment];

  @override
  final String wireName = r'ChatQuotationDiscountAssessment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationDiscountAssessment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(ChatQuotationDiscountAssessmentScopeEnum),
    );
    yield r'percent';
    yield serializers.serialize(
      object.percent,
      specifiedType: const FullType(String),
    );
    yield r'basis_centavos';
    yield serializers.serialize(
      object.basisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'deduction_centavos';
    yield serializers.serialize(
      object.deductionCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationDiscountAssessment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationDiscountAssessmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatQuotationDiscountAssessmentScopeEnum),
          ) as ChatQuotationDiscountAssessmentScopeEnum;
          result.scope = valueDes;
          break;
        case r'percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.percent = valueDes;
          break;
        case r'basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.basisCentavos = valueDes;
          break;
        case r'deduction_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deductionCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationDiscountAssessment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationDiscountAssessmentBuilder();
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


class ChatQuotationDiscountAssessmentScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MATERIALS')
  static const ChatQuotationDiscountAssessmentScopeEnum MATERIALS = _$chatQuotationDiscountAssessmentScopeEnum_MATERIALS;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ChatQuotationDiscountAssessmentScopeEnum DELIVERY = _$chatQuotationDiscountAssessmentScopeEnum_DELIVERY;

  static Serializer<ChatQuotationDiscountAssessmentScopeEnum> get serializer => _$chatQuotationDiscountAssessmentScopeEnumSerializer;

  const ChatQuotationDiscountAssessmentScopeEnum._(String name): super(name);

  static BuiltSet<ChatQuotationDiscountAssessmentScopeEnum> get values => _$chatQuotationDiscountAssessmentScopeEnumValues;
  static ChatQuotationDiscountAssessmentScopeEnum valueOf(String name) => _$chatQuotationDiscountAssessmentScopeEnumValueOf(name);
}

