//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_receipt.g.dart';

/// FulfillmentReceipt
///
/// Properties:
/// * [dueAt]
/// * [paused]
/// * [remainingSeconds]
/// * [confirmedAt]
/// * [confirmationSource]
/// * [windowHours]
@BuiltValue()
abstract class FulfillmentReceipt implements Built<FulfillmentReceipt, FulfillmentReceiptBuilder> {
  @BuiltValueField(wireName: r'due_at')
  DateTime? get dueAt;

  @BuiltValueField(wireName: r'paused')
  bool get paused;

  @BuiltValueField(wireName: r'remaining_seconds')
  int? get remainingSeconds;

  @BuiltValueField(wireName: r'confirmed_at')
  DateTime? get confirmedAt;

  @BuiltValueField(wireName: r'confirmation_source')
  FulfillmentReceiptConfirmationSourceEnum? get confirmationSource;
  // enum confirmationSourceEnum {  BUYER,  AUTO_CONFIRMATION,  };

  @BuiltValueField(wireName: r'window_hours')
  int get windowHours;

  FulfillmentReceipt._();

  factory FulfillmentReceipt([void updates(FulfillmentReceiptBuilder b)]) = _$FulfillmentReceipt;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentReceiptBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentReceipt> get serializer => _$FulfillmentReceiptSerializer();
}

class _$FulfillmentReceiptSerializer implements PrimitiveSerializer<FulfillmentReceipt> {
  @override
  final Iterable<Type> types = const [FulfillmentReceipt, _$FulfillmentReceipt];

  @override
  final String wireName = r'FulfillmentReceipt';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dueAt != null) {
      yield r'due_at';
      yield serializers.serialize(
        object.dueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'paused';
    yield serializers.serialize(
      object.paused,
      specifiedType: const FullType(bool),
    );
    if (object.remainingSeconds != null) {
      yield r'remaining_seconds';
      yield serializers.serialize(
        object.remainingSeconds,
        specifiedType: const FullType(int),
      );
    }
    if (object.confirmedAt != null) {
      yield r'confirmed_at';
      yield serializers.serialize(
        object.confirmedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.confirmationSource != null) {
      yield r'confirmation_source';
      yield serializers.serialize(
        object.confirmationSource,
        specifiedType: const FullType(FulfillmentReceiptConfirmationSourceEnum),
      );
    }
    yield r'window_hours';
    yield serializers.serialize(
      object.windowHours,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentReceiptBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueAt = valueDes;
          break;
        case r'paused':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.paused = valueDes;
          break;
        case r'remaining_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.remainingSeconds = valueDes;
          break;
        case r'confirmed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.confirmedAt = valueDes;
          break;
        case r'confirmation_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentReceiptConfirmationSourceEnum),
          ) as FulfillmentReceiptConfirmationSourceEnum?;
          if (valueDes == null) continue;
          result.confirmationSource = valueDes;
          break;
        case r'window_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.windowHours = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentReceipt deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentReceiptBuilder();
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


class FulfillmentReceiptConfirmationSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const FulfillmentReceiptConfirmationSourceEnum BUYER = _$fulfillmentReceiptConfirmationSourceEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'AUTO_CONFIRMATION')
  static const FulfillmentReceiptConfirmationSourceEnum AUTO_CONFIRMATION = _$fulfillmentReceiptConfirmationSourceEnum_AUTO_CONFIRMATION;

  static Serializer<FulfillmentReceiptConfirmationSourceEnum> get serializer => _$fulfillmentReceiptConfirmationSourceEnumSerializer;

  const FulfillmentReceiptConfirmationSourceEnum._(String name): super(name);

  static BuiltSet<FulfillmentReceiptConfirmationSourceEnum> get values => _$fulfillmentReceiptConfirmationSourceEnumValues;
  static FulfillmentReceiptConfirmationSourceEnum valueOf(String name) => _$fulfillmentReceiptConfirmationSourceEnumValueOf(name);
}

