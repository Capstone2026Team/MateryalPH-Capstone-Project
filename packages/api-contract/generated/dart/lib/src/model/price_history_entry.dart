//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/tax_category.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'price_history_entry.g.dart';

/// PriceHistoryEntry
///
/// Properties:
/// * [priceVersionId]
/// * [version]
/// * [priceKind]
/// * [amountCentavos]
/// * [taxCategory]
/// * [minimumQuantity]
/// * [includedVatCentavos]
/// * [effectiveAt]
/// * [retiredAt]
/// * [supersedesPriceVersionId]
/// * [current]
/// * [createdBy]
@BuiltValue()
abstract class PriceHistoryEntry implements Built<PriceHistoryEntry, PriceHistoryEntryBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'price_kind')
  PriceHistoryEntryPriceKindEnum get priceKind;
  // enum priceKindEnum {  ORDINARY,  PROMOTIONAL,  VOLUME_TIER,  NEGOTIATED,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'tax_category')
  TaxCategory get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  @BuiltValueField(wireName: r'minimum_quantity')
  String? get minimumQuantity;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'effective_at')
  String? get effectiveAt;

  @BuiltValueField(wireName: r'retired_at')
  String? get retiredAt;

  @BuiltValueField(wireName: r'supersedes_price_version_id')
  String? get supersedesPriceVersionId;

  @BuiltValueField(wireName: r'current')
  bool get current;

  @BuiltValueField(wireName: r'created_by')
  String? get createdBy;

  PriceHistoryEntry._();

  factory PriceHistoryEntry([void updates(PriceHistoryEntryBuilder b)]) = _$PriceHistoryEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PriceHistoryEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PriceHistoryEntry> get serializer => _$PriceHistoryEntrySerializer();
}

class _$PriceHistoryEntrySerializer implements PrimitiveSerializer<PriceHistoryEntry> {
  @override
  final Iterable<Type> types = const [PriceHistoryEntry, _$PriceHistoryEntry];

  @override
  final String wireName = r'PriceHistoryEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PriceHistoryEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'price_version_id';
    yield serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'price_kind';
    yield serializers.serialize(
      object.priceKind,
      specifiedType: const FullType(PriceHistoryEntryPriceKindEnum),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(TaxCategory),
    );
    yield r'minimum_quantity';
    yield object.minimumQuantity == null ? null : serializers.serialize(
      object.minimumQuantity,
      specifiedType: const FullType.nullable(String),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'effective_at';
    yield object.effectiveAt == null ? null : serializers.serialize(
      object.effectiveAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'retired_at';
    yield object.retiredAt == null ? null : serializers.serialize(
      object.retiredAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'supersedes_price_version_id';
    yield object.supersedesPriceVersionId == null ? null : serializers.serialize(
      object.supersedesPriceVersionId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(bool),
    );
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PriceHistoryEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PriceHistoryEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceVersionId = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'price_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PriceHistoryEntryPriceKindEnum),
          ) as PriceHistoryEntryPriceKindEnum;
          result.priceKind = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxCategory),
          ) as TaxCategory;
          result.taxCategory = valueDes;
          break;
        case r'minimum_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.minimumQuantity = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        case r'effective_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.effectiveAt = valueDes;
          break;
        case r'retired_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.retiredAt = valueDes;
          break;
        case r'supersedes_price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supersedesPriceVersionId = valueDes;
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.current = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PriceHistoryEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PriceHistoryEntryBuilder();
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


class PriceHistoryEntryPriceKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDINARY')
  static const PriceHistoryEntryPriceKindEnum ORDINARY = _$priceHistoryEntryPriceKindEnum_ORDINARY;
  @BuiltValueEnumConst(wireName: r'PROMOTIONAL')
  static const PriceHistoryEntryPriceKindEnum PROMOTIONAL = _$priceHistoryEntryPriceKindEnum_PROMOTIONAL;
  @BuiltValueEnumConst(wireName: r'VOLUME_TIER')
  static const PriceHistoryEntryPriceKindEnum VOLUME_TIER = _$priceHistoryEntryPriceKindEnum_VOLUME_TIER;
  @BuiltValueEnumConst(wireName: r'NEGOTIATED')
  static const PriceHistoryEntryPriceKindEnum NEGOTIATED = _$priceHistoryEntryPriceKindEnum_NEGOTIATED;

  static Serializer<PriceHistoryEntryPriceKindEnum> get serializer => _$priceHistoryEntryPriceKindEnumSerializer;

  const PriceHistoryEntryPriceKindEnum._(String name): super(name);

  static BuiltSet<PriceHistoryEntryPriceKindEnum> get values => _$priceHistoryEntryPriceKindEnumValues;
  static PriceHistoryEntryPriceKindEnum valueOf(String name) => _$priceHistoryEntryPriceKindEnumValueOf(name);
}

