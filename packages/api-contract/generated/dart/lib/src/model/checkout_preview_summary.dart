//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_preview_summary.g.dart';

/// CheckoutPreviewSummary
///
/// Properties:
/// * [groupCount]
/// * [readyGroups]
/// * [actionRequiredGroups]
/// * [blockedGroups]
/// * [requiresSplitConfirmation]
/// * [createsOrders]
/// * [reservesStock]
/// * [notice]
@BuiltValue()
abstract class CheckoutPreviewSummary implements Built<CheckoutPreviewSummary, CheckoutPreviewSummaryBuilder> {
  @BuiltValueField(wireName: r'group_count')
  int get groupCount;

  @BuiltValueField(wireName: r'ready_groups')
  int get readyGroups;

  @BuiltValueField(wireName: r'action_required_groups')
  int get actionRequiredGroups;

  @BuiltValueField(wireName: r'blocked_groups')
  int get blockedGroups;

  @BuiltValueField(wireName: r'requires_split_confirmation')
  bool get requiresSplitConfirmation;

  @BuiltValueField(wireName: r'creates_orders')
  CheckoutPreviewSummaryCreatesOrdersEnum get createsOrders;
  // enum createsOrdersEnum {  false,  };

  @BuiltValueField(wireName: r'reserves_stock')
  CheckoutPreviewSummaryReservesStockEnum get reservesStock;
  // enum reservesStockEnum {  false,  };

  @BuiltValueField(wireName: r'notice')
  String get notice;

  CheckoutPreviewSummary._();

  factory CheckoutPreviewSummary([void updates(CheckoutPreviewSummaryBuilder b)]) = _$CheckoutPreviewSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutPreviewSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutPreviewSummary> get serializer => _$CheckoutPreviewSummarySerializer();
}

class _$CheckoutPreviewSummarySerializer implements PrimitiveSerializer<CheckoutPreviewSummary> {
  @override
  final Iterable<Type> types = const [CheckoutPreviewSummary, _$CheckoutPreviewSummary];

  @override
  final String wireName = r'CheckoutPreviewSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutPreviewSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'group_count';
    yield serializers.serialize(
      object.groupCount,
      specifiedType: const FullType(int),
    );
    yield r'ready_groups';
    yield serializers.serialize(
      object.readyGroups,
      specifiedType: const FullType(int),
    );
    yield r'action_required_groups';
    yield serializers.serialize(
      object.actionRequiredGroups,
      specifiedType: const FullType(int),
    );
    yield r'blocked_groups';
    yield serializers.serialize(
      object.blockedGroups,
      specifiedType: const FullType(int),
    );
    yield r'requires_split_confirmation';
    yield serializers.serialize(
      object.requiresSplitConfirmation,
      specifiedType: const FullType(bool),
    );
    yield r'creates_orders';
    yield serializers.serialize(
      object.createsOrders,
      specifiedType: const FullType(CheckoutPreviewSummaryCreatesOrdersEnum),
    );
    yield r'reserves_stock';
    yield serializers.serialize(
      object.reservesStock,
      specifiedType: const FullType(CheckoutPreviewSummaryReservesStockEnum),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutPreviewSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutPreviewSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.groupCount = valueDes;
          break;
        case r'ready_groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.readyGroups = valueDes;
          break;
        case r'action_required_groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.actionRequiredGroups = valueDes;
          break;
        case r'blocked_groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.blockedGroups = valueDes;
          break;
        case r'requires_split_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requiresSplitConfirmation = valueDes;
          break;
        case r'creates_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutPreviewSummaryCreatesOrdersEnum),
          ) as CheckoutPreviewSummaryCreatesOrdersEnum;
          result.createsOrders = valueDes;
          break;
        case r'reserves_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutPreviewSummaryReservesStockEnum),
          ) as CheckoutPreviewSummaryReservesStockEnum;
          result.reservesStock = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutPreviewSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutPreviewSummaryBuilder();
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


class CheckoutPreviewSummaryCreatesOrdersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'false')
  static const CheckoutPreviewSummaryCreatesOrdersEnum false_ = _$checkoutPreviewSummaryCreatesOrdersEnum_false_;

  static Serializer<CheckoutPreviewSummaryCreatesOrdersEnum> get serializer => _$checkoutPreviewSummaryCreatesOrdersEnumSerializer;

  const CheckoutPreviewSummaryCreatesOrdersEnum._(String name): super(name);

  static BuiltSet<CheckoutPreviewSummaryCreatesOrdersEnum> get values => _$checkoutPreviewSummaryCreatesOrdersEnumValues;
  static CheckoutPreviewSummaryCreatesOrdersEnum valueOf(String name) => _$checkoutPreviewSummaryCreatesOrdersEnumValueOf(name);
}

class CheckoutPreviewSummaryReservesStockEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'false')
  static const CheckoutPreviewSummaryReservesStockEnum false_ = _$checkoutPreviewSummaryReservesStockEnum_false_;

  static Serializer<CheckoutPreviewSummaryReservesStockEnum> get serializer => _$checkoutPreviewSummaryReservesStockEnumSerializer;

  const CheckoutPreviewSummaryReservesStockEnum._(String name): super(name);

  static BuiltSet<CheckoutPreviewSummaryReservesStockEnum> get values => _$checkoutPreviewSummaryReservesStockEnumValues;
  static CheckoutPreviewSummaryReservesStockEnum valueOf(String name) => _$checkoutPreviewSummaryReservesStockEnumValueOf(name);
}

