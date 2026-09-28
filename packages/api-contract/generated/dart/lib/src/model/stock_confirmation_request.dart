//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/stock_confirmation_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stock_confirmation_request.g.dart';

/// StockConfirmationRequest
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class StockConfirmationRequest implements Built<StockConfirmationRequest, StockConfirmationRequestBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<StockConfirmationItem> get items;

  StockConfirmationRequest._();

  factory StockConfirmationRequest([void updates(StockConfirmationRequestBuilder b)]) = _$StockConfirmationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StockConfirmationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StockConfirmationRequest> get serializer => _$StockConfirmationRequestSerializer();
}

class _$StockConfirmationRequestSerializer implements PrimitiveSerializer<StockConfirmationRequest> {
  @override
  final Iterable<Type> types = const [StockConfirmationRequest, _$StockConfirmationRequest];

  @override
  final String wireName = r'StockConfirmationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StockConfirmationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(StockConfirmationItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StockConfirmationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StockConfirmationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(StockConfirmationItem)]),
          ) as BuiltList<StockConfirmationItem>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StockConfirmationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StockConfirmationRequestBuilder();
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


