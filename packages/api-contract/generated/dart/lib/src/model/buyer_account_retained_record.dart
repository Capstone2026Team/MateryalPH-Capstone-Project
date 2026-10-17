//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_account_retained_record.g.dart';

/// BuyerAccountRetainedRecord
///
/// Properties:
/// * [category]
/// * [purpose]
@BuiltValue()
abstract class BuyerAccountRetainedRecord implements Built<BuyerAccountRetainedRecord, BuyerAccountRetainedRecordBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  BuyerAccountRetainedRecord._();

  factory BuyerAccountRetainedRecord([void updates(BuyerAccountRetainedRecordBuilder b)]) = _$BuyerAccountRetainedRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAccountRetainedRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAccountRetainedRecord> get serializer => _$BuyerAccountRetainedRecordSerializer();
}

class _$BuyerAccountRetainedRecordSerializer implements PrimitiveSerializer<BuyerAccountRetainedRecord> {
  @override
  final Iterable<Type> types = const [BuyerAccountRetainedRecord, _$BuyerAccountRetainedRecord];

  @override
  final String wireName = r'BuyerAccountRetainedRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAccountRetainedRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAccountRetainedRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAccountRetainedRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAccountRetainedRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAccountRetainedRecordBuilder();
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


