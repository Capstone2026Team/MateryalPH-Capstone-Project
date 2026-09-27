//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_list_meta.g.dart';

/// CatalogListingListMeta
///
/// Properties:
/// * [currentPage]
/// * [lastPage]
/// * [total]
/// * [scope]
/// * [statusCounts] - Listing count per status within the current search and category scope, ignoring the status filter.
/// * [activeOutOfStock] - Active listings in the same scope with no available-to-sell stock.
@BuiltValue()
abstract class CatalogListingListMeta implements Built<CatalogListingListMeta, CatalogListingListMetaBuilder> {
  @BuiltValueField(wireName: r'current_page')
  int? get currentPage;

  @BuiltValueField(wireName: r'last_page')
  int? get lastPage;

  @BuiltValueField(wireName: r'total')
  int? get total;

  @BuiltValueField(wireName: r'scope')
  CatalogListingListMetaScopeEnum? get scope;
  // enum scopeEnum {  ORGANIZATION,  ASSIGNED_ONLY,  };

  /// Listing count per status within the current search and category scope, ignoring the status filter.
  @BuiltValueField(wireName: r'status_counts')
  BuiltMap<String, int>? get statusCounts;

  /// Active listings in the same scope with no available-to-sell stock.
  @BuiltValueField(wireName: r'active_out_of_stock')
  int? get activeOutOfStock;

  CatalogListingListMeta._();

  factory CatalogListingListMeta([void updates(CatalogListingListMetaBuilder b)]) = _$CatalogListingListMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingListMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingListMeta> get serializer => _$CatalogListingListMetaSerializer();
}

class _$CatalogListingListMetaSerializer implements PrimitiveSerializer<CatalogListingListMeta> {
  @override
  final Iterable<Type> types = const [CatalogListingListMeta, _$CatalogListingListMeta];

  @override
  final String wireName = r'CatalogListingListMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.currentPage != null) {
      yield r'current_page';
      yield serializers.serialize(
        object.currentPage,
        specifiedType: const FullType(int),
      );
    }
    if (object.lastPage != null) {
      yield r'last_page';
      yield serializers.serialize(
        object.lastPage,
        specifiedType: const FullType(int),
      );
    }
    if (object.total != null) {
      yield r'total';
      yield serializers.serialize(
        object.total,
        specifiedType: const FullType(int),
      );
    }
    if (object.scope != null) {
      yield r'scope';
      yield serializers.serialize(
        object.scope,
        specifiedType: const FullType(CatalogListingListMetaScopeEnum),
      );
    }
    if (object.statusCounts != null) {
      yield r'status_counts';
      yield serializers.serialize(
        object.statusCounts,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
      );
    }
    if (object.activeOutOfStock != null) {
      yield r'active_out_of_stock';
      yield serializers.serialize(
        object.activeOutOfStock,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListingListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingListMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.currentPage = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lastPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.total = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CatalogListingListMetaScopeEnum),
          ) as CatalogListingListMetaScopeEnum?;
          if (valueDes == null) continue;
          result.scope = valueDes;
          break;
        case r'status_counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>?;
          if (valueDes == null) continue;
          result.statusCounts.replace(valueDes);
          break;
        case r'active_out_of_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.activeOutOfStock = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListingListMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingListMetaBuilder();
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


class CatalogListingListMetaScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORGANIZATION')
  static const CatalogListingListMetaScopeEnum ORGANIZATION = _$catalogListingListMetaScopeEnum_ORGANIZATION;
  @BuiltValueEnumConst(wireName: r'ASSIGNED_ONLY')
  static const CatalogListingListMetaScopeEnum ASSIGNED_ONLY = _$catalogListingListMetaScopeEnum_ASSIGNED_ONLY;

  static Serializer<CatalogListingListMetaScopeEnum> get serializer => _$catalogListingListMetaScopeEnumSerializer;

  const CatalogListingListMetaScopeEnum._(String name): super(name);

  static BuiltSet<CatalogListingListMetaScopeEnum> get values => _$catalogListingListMetaScopeEnumValues;
  static CatalogListingListMetaScopeEnum valueOf(String name) => _$catalogListingListMetaScopeEnumValueOf(name);
}

