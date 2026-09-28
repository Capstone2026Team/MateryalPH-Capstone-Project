//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/inventory_balance.dart';
import 'package:materyalph_api_client/src/model/stock_confirmation_schedule.dart';
import 'package:materyalph_api_client/src/model/inventory_price.dart';
import 'package:materyalph_api_client/src/model/listing_status.dart';
import 'package:materyalph_api_client/src/model/auto_accept_policy.dart';
import 'package:materyalph_api_client/src/model/inventory_comparability.dart';
import 'package:materyalph_api_client/src/model/stock_label.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_row.g.dart';

/// InventoryRow
///
/// Properties:
/// * [listingVariantId]
/// * [listingId]
/// * [listingName]
/// * [listingStatus]
/// * [variantLabel]
/// * [sku]
/// * [unitCode]
/// * [lockVersion] - Inventory row version; 0 before the first count.
/// * [inventory]
/// * [publicLabel]
/// * [stockConfirmation]
/// * [listingConfirmation]
/// * [price]
/// * [comparability]
/// * [autoAccept]
@BuiltValue()
abstract class InventoryRow implements Built<InventoryRow, InventoryRowBuilder> {
  @BuiltValueField(wireName: r'listing_variant_id')
  String get listingVariantId;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'listing_name')
  String get listingName;

  @BuiltValueField(wireName: r'listing_status')
  ListingStatus get listingStatus;
  // enum listingStatusEnum {  DRAFT,  PENDING_COMPLIANCE,  PENDING_ADMIN_REVIEW,  ACTIVE,  INACTIVE,  TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED,  REJECTED,  };

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  /// Inventory row version; 0 before the first count.
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'inventory')
  InventoryBalance? get inventory;

  @BuiltValueField(wireName: r'public_label')
  StockLabel get publicLabel;
  // enum publicLabelEnum {  IN_STOCK,  LIMITED_STOCK,  OUT_OF_STOCK,  };

  @BuiltValueField(wireName: r'stock_confirmation')
  StockConfirmationSchedule get stockConfirmation;

  @BuiltValueField(wireName: r'listing_confirmation')
  StockConfirmationSchedule get listingConfirmation;

  @BuiltValueField(wireName: r'price')
  InventoryPrice? get price;

  @BuiltValueField(wireName: r'comparability')
  InventoryComparability get comparability;

  @BuiltValueField(wireName: r'auto_accept')
  AutoAcceptPolicy get autoAccept;

  InventoryRow._();

  factory InventoryRow([void updates(InventoryRowBuilder b)]) = _$InventoryRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryRow> get serializer => _$InventoryRowSerializer();
}

class _$InventoryRowSerializer implements PrimitiveSerializer<InventoryRow> {
  @override
  final Iterable<Type> types = const [InventoryRow, _$InventoryRow];

  @override
  final String wireName = r'InventoryRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_variant_id';
    yield serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType(String),
    );
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'listing_name';
    yield serializers.serialize(
      object.listingName,
      specifiedType: const FullType(String),
    );
    yield r'listing_status';
    yield serializers.serialize(
      object.listingStatus,
      specifiedType: const FullType(ListingStatus),
    );
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'sku';
    yield serializers.serialize(
      object.sku,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'inventory';
    yield object.inventory == null ? null : serializers.serialize(
      object.inventory,
      specifiedType: const FullType.nullable(InventoryBalance),
    );
    yield r'public_label';
    yield serializers.serialize(
      object.publicLabel,
      specifiedType: const FullType(StockLabel),
    );
    yield r'stock_confirmation';
    yield serializers.serialize(
      object.stockConfirmation,
      specifiedType: const FullType(StockConfirmationSchedule),
    );
    yield r'listing_confirmation';
    yield serializers.serialize(
      object.listingConfirmation,
      specifiedType: const FullType(StockConfirmationSchedule),
    );
    yield r'price';
    yield object.price == null ? null : serializers.serialize(
      object.price,
      specifiedType: const FullType.nullable(InventoryPrice),
    );
    yield r'comparability';
    yield serializers.serialize(
      object.comparability,
      specifiedType: const FullType(InventoryComparability),
    );
    yield r'auto_accept';
    yield serializers.serialize(
      object.autoAccept,
      specifiedType: const FullType(AutoAcceptPolicy),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingVariantId = valueDes;
          break;
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'listing_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingName = valueDes;
          break;
        case r'listing_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingStatus),
          ) as ListingStatus;
          result.listingStatus = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sku = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'inventory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InventoryBalance),
          ) as InventoryBalance?;
          if (valueDes == null) continue;
          result.inventory.replace(valueDes);
          break;
        case r'public_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StockLabel),
          ) as StockLabel;
          result.publicLabel = valueDes;
          break;
        case r'stock_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StockConfirmationSchedule),
          ) as StockConfirmationSchedule;
          result.stockConfirmation.replace(valueDes);
          break;
        case r'listing_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StockConfirmationSchedule),
          ) as StockConfirmationSchedule;
          result.listingConfirmation.replace(valueDes);
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InventoryPrice),
          ) as InventoryPrice?;
          if (valueDes == null) continue;
          result.price.replace(valueDes);
          break;
        case r'comparability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryComparability),
          ) as InventoryComparability;
          result.comparability.replace(valueDes);
          break;
        case r'auto_accept':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicy),
          ) as AutoAcceptPolicy;
          result.autoAccept.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryRowBuilder();
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


