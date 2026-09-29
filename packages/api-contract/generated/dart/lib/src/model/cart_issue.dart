//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_issue.g.dart';

/// CartIssue
///
/// Properties:
/// * [code]
/// * [severity]
/// * [message]
@BuiltValue()
abstract class CartIssue implements Built<CartIssue, CartIssueBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'severity')
  CartIssueSeverityEnum get severity;
  // enum severityEnum {  BLOCKING,  ACTION_REQUIRED,  INFO,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  CartIssue._();

  factory CartIssue([void updates(CartIssueBuilder b)]) = _$CartIssue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartIssueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartIssue> get serializer => _$CartIssueSerializer();
}

class _$CartIssueSerializer implements PrimitiveSerializer<CartIssue> {
  @override
  final Iterable<Type> types = const [CartIssue, _$CartIssue];

  @override
  final String wireName = r'CartIssue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(CartIssueSeverityEnum),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartIssueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartIssueSeverityEnum),
          ) as CartIssueSeverityEnum;
          result.severity = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartIssue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartIssueBuilder();
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


class CartIssueSeverityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BLOCKING')
  static const CartIssueSeverityEnum BLOCKING = _$cartIssueSeverityEnum_BLOCKING;
  @BuiltValueEnumConst(wireName: r'ACTION_REQUIRED')
  static const CartIssueSeverityEnum ACTION_REQUIRED = _$cartIssueSeverityEnum_ACTION_REQUIRED;
  @BuiltValueEnumConst(wireName: r'INFO')
  static const CartIssueSeverityEnum INFO = _$cartIssueSeverityEnum_INFO;

  static Serializer<CartIssueSeverityEnum> get serializer => _$cartIssueSeverityEnumSerializer;

  const CartIssueSeverityEnum._(String name): super(name);

  static BuiltSet<CartIssueSeverityEnum> get values => _$cartIssueSeverityEnumValues;
  static CartIssueSeverityEnum valueOf(String name) => _$cartIssueSeverityEnumValueOf(name);
}

