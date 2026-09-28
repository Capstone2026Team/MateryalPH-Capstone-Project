//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/inventory_ledger_meta_permissions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/inventory_ledger_meta_stale_listings.dart';
import 'package:materyalph_api_client/src/model/inventory_ledger_meta_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_ledger_meta.g.dart';

/// InventoryLedgerMeta
///
/// Properties:
/// * [currentPage]
/// * [lastPage]
/// * [total]
/// * [pageSize]
/// * [summary]
/// * [staleListings]
/// * [labelRuleVersion]
/// * [timezone]
/// * [permissions]
@BuiltValue()
abstract class InventoryLedgerMeta implements Built<InventoryLedgerMeta, InventoryLedgerMetaBuilder> {
  @BuiltValueField(wireName: r'current_page')
  int get currentPage;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'page_size')
  int get pageSize;

  @BuiltValueField(wireName: r'summary')
  InventoryLedgerMetaSummary get summary;

  @BuiltValueField(wireName: r'stale_listings')
  InventoryLedgerMetaStaleListings get staleListings;

  @BuiltValueField(wireName: r'label_rule_version')
  String get labelRuleVersion;

  @BuiltValueField(wireName: r'timezone')
  InventoryLedgerMetaTimezoneEnum get timezone;
  // enum timezoneEnum {  Asia/Manila,  };

  @BuiltValueField(wireName: r'permissions')
  InventoryLedgerMetaPermissions get permissions;

  InventoryLedgerMeta._();

  factory InventoryLedgerMeta([void updates(InventoryLedgerMetaBuilder b)]) = _$InventoryLedgerMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryLedgerMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryLedgerMeta> get serializer => _$InventoryLedgerMetaSerializer();
}

class _$InventoryLedgerMetaSerializer implements PrimitiveSerializer<InventoryLedgerMeta> {
  @override
  final Iterable<Type> types = const [InventoryLedgerMeta, _$InventoryLedgerMeta];

  @override
  final String wireName = r'InventoryLedgerMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryLedgerMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current_page';
    yield serializers.serialize(
      object.currentPage,
      specifiedType: const FullType(int),
    );
    yield r'last_page';
    yield serializers.serialize(
      object.lastPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'page_size';
    yield serializers.serialize(
      object.pageSize,
      specifiedType: const FullType(int),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(InventoryLedgerMetaSummary),
    );
    yield r'stale_listings';
    yield serializers.serialize(
      object.staleListings,
      specifiedType: const FullType(InventoryLedgerMetaStaleListings),
    );
    yield r'label_rule_version';
    yield serializers.serialize(
      object.labelRuleVersion,
      specifiedType: const FullType(String),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(InventoryLedgerMetaTimezoneEnum),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(InventoryLedgerMetaPermissions),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryLedgerMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryLedgerMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.currentPage = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'page_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pageSize = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryLedgerMetaSummary),
          ) as InventoryLedgerMetaSummary;
          result.summary.replace(valueDes);
          break;
        case r'stale_listings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryLedgerMetaStaleListings),
          ) as InventoryLedgerMetaStaleListings;
          result.staleListings.replace(valueDes);
          break;
        case r'label_rule_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.labelRuleVersion = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryLedgerMetaTimezoneEnum),
          ) as InventoryLedgerMetaTimezoneEnum;
          result.timezone = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryLedgerMetaPermissions),
          ) as InventoryLedgerMetaPermissions;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryLedgerMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryLedgerMetaBuilder();
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


class InventoryLedgerMetaTimezoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Asia/Manila')
  static const InventoryLedgerMetaTimezoneEnum asiaSlashManila = _$inventoryLedgerMetaTimezoneEnum_asiaSlashManila;

  static Serializer<InventoryLedgerMetaTimezoneEnum> get serializer => _$inventoryLedgerMetaTimezoneEnumSerializer;

  const InventoryLedgerMetaTimezoneEnum._(String name): super(name);

  static BuiltSet<InventoryLedgerMetaTimezoneEnum> get values => _$inventoryLedgerMetaTimezoneEnumValues;
  static InventoryLedgerMetaTimezoneEnum valueOf(String name) => _$inventoryLedgerMetaTimezoneEnumValueOf(name);
}

