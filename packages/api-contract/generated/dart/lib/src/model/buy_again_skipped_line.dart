//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buy_again_skipped_line.g.dart';

/// BuyAgainSkippedLine
///
/// Properties:
/// * [displayName]
/// * [reasonCode]
/// * [message]
@BuiltValue()
abstract class BuyAgainSkippedLine implements Built<BuyAgainSkippedLine, BuyAgainSkippedLineBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'reason_code')
  BuyAgainSkippedLineReasonCodeEnum get reasonCode;
  // enum reasonCodeEnum {  LISTING_UNAVAILABLE,  OUTSIDE_SELECTED_RADIUS,  STORE_ON_VACATION,  QUANTITY_INVALID,  QUANTITY_UNAVAILABLE,  CART_FULL,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  BuyAgainSkippedLine._();

  factory BuyAgainSkippedLine([void updates(BuyAgainSkippedLineBuilder b)]) = _$BuyAgainSkippedLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyAgainSkippedLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyAgainSkippedLine> get serializer => _$BuyAgainSkippedLineSerializer();
}

class _$BuyAgainSkippedLineSerializer implements PrimitiveSerializer<BuyAgainSkippedLine> {
  @override
  final Iterable<Type> types = const [BuyAgainSkippedLine, _$BuyAgainSkippedLine];

  @override
  final String wireName = r'BuyAgainSkippedLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyAgainSkippedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(BuyAgainSkippedLineReasonCodeEnum),
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
    BuyAgainSkippedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyAgainSkippedLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyAgainSkippedLineReasonCodeEnum),
          ) as BuyAgainSkippedLineReasonCodeEnum;
          result.reasonCode = valueDes;
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
  BuyAgainSkippedLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyAgainSkippedLineBuilder();
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


class BuyAgainSkippedLineReasonCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'LISTING_UNAVAILABLE')
  static const BuyAgainSkippedLineReasonCodeEnum LISTING_UNAVAILABLE = _$buyAgainSkippedLineReasonCodeEnum_LISTING_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'OUTSIDE_SELECTED_RADIUS')
  static const BuyAgainSkippedLineReasonCodeEnum OUTSIDE_SELECTED_RADIUS = _$buyAgainSkippedLineReasonCodeEnum_OUTSIDE_SELECTED_RADIUS;
  @BuiltValueEnumConst(wireName: r'STORE_ON_VACATION')
  static const BuyAgainSkippedLineReasonCodeEnum STORE_ON_VACATION = _$buyAgainSkippedLineReasonCodeEnum_STORE_ON_VACATION;
  @BuiltValueEnumConst(wireName: r'QUANTITY_INVALID')
  static const BuyAgainSkippedLineReasonCodeEnum QUANTITY_INVALID = _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_INVALID;
  @BuiltValueEnumConst(wireName: r'QUANTITY_UNAVAILABLE')
  static const BuyAgainSkippedLineReasonCodeEnum QUANTITY_UNAVAILABLE = _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'CART_FULL')
  static const BuyAgainSkippedLineReasonCodeEnum CART_FULL = _$buyAgainSkippedLineReasonCodeEnum_CART_FULL;

  static Serializer<BuyAgainSkippedLineReasonCodeEnum> get serializer => _$buyAgainSkippedLineReasonCodeEnumSerializer;

  const BuyAgainSkippedLineReasonCodeEnum._(String name): super(name);

  static BuiltSet<BuyAgainSkippedLineReasonCodeEnum> get values => _$buyAgainSkippedLineReasonCodeEnumValues;
  static BuyAgainSkippedLineReasonCodeEnum valueOf(String name) => _$buyAgainSkippedLineReasonCodeEnumValueOf(name);
}

