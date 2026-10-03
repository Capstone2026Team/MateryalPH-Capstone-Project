//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/cart_line_current.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/cart_issue.dart';
import 'package:materyalph_api_client/src/model/cart_line_snapshot.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_line.g.dart';

/// CartLine
///
/// Properties:
/// * [id]
/// * [lockVersion]
/// * [listingId]
/// * [variantId]
/// * [vendorId]
/// * [displayName]
/// * [variantLabel]
/// * [image]
/// * [unitCode]
/// * [unitName]
/// * [quantity]
/// * [quantityStep]
/// * [savedForLater]
/// * [snapshot]
/// * [current] - Null when the offer is no longer eligible.
/// * [lineTotalCentavos]
/// * [issues]
/// * [status]
@BuiltValue()
abstract class CartLine implements Built<CartLine, CartLineBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'variant_id')
  String get variantId;

  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'unit_name')
  String get unitName;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'quantity_step')
  String get quantityStep;

  @BuiltValueField(wireName: r'saved_for_later')
  bool get savedForLater;

  @BuiltValueField(wireName: r'snapshot')
  CartLineSnapshot get snapshot;

  /// Null when the offer is no longer eligible.
  @BuiltValueField(wireName: r'current')
  CartLineCurrent? get current;

  @BuiltValueField(wireName: r'line_total_centavos')
  int? get lineTotalCentavos;

  @BuiltValueField(wireName: r'issues')
  BuiltList<CartIssue> get issues;

  @BuiltValueField(wireName: r'status')
  CartLineStatusEnum get status;
  // enum statusEnum {  READY,  ACTION_REQUIRED,  BLOCKED,  };

  CartLine._();

  factory CartLine([void updates(CartLineBuilder b)]) = _$CartLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartLine> get serializer => _$CartLineSerializer();
}

class _$CartLineSerializer implements PrimitiveSerializer<CartLine> {
  @override
  final Iterable<Type> types = const [CartLine, _$CartLine];

  @override
  final String wireName = r'CartLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'variant_id';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'variant_label';
    yield object.variantLabel == null ? null : serializers.serialize(
      object.variantLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'image';
    yield object.image == null ? null : serializers.serialize(
      object.image,
      specifiedType: const FullType.nullable(ListingImage),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'unit_name';
    yield serializers.serialize(
      object.unitName,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    yield r'quantity_step';
    yield serializers.serialize(
      object.quantityStep,
      specifiedType: const FullType(String),
    );
    yield r'saved_for_later';
    yield serializers.serialize(
      object.savedForLater,
      specifiedType: const FullType(bool),
    );
    yield r'snapshot';
    yield serializers.serialize(
      object.snapshot,
      specifiedType: const FullType(CartLineSnapshot),
    );
    yield r'current';
    yield object.current == null ? null : serializers.serialize(
      object.current,
      specifiedType: const FullType.nullable(CartLineCurrent),
    );
    yield r'line_total_centavos';
    yield object.lineTotalCentavos == null ? null : serializers.serialize(
      object.lineTotalCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList, [FullType(CartIssue)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CartLineStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'unit_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitName = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'quantity_step':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantityStep = valueDes;
          break;
        case r'saved_for_later':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.savedForLater = valueDes;
          break;
        case r'snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartLineSnapshot),
          ) as CartLineSnapshot;
          result.snapshot.replace(valueDes);
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartLineCurrent),
          ) as CartLineCurrent?;
          if (valueDes == null) continue;
          result.current.replace(valueDes);
          break;
        case r'line_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lineTotalCentavos = valueDes;
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartIssue)]),
          ) as BuiltList<CartIssue>;
          result.issues.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartLineStatusEnum),
          ) as CartLineStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartLineBuilder();
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


class CartLineStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'READY')
  static const CartLineStatusEnum READY = _$cartLineStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'ACTION_REQUIRED')
  static const CartLineStatusEnum ACTION_REQUIRED = _$cartLineStatusEnum_ACTION_REQUIRED;
  @BuiltValueEnumConst(wireName: r'BLOCKED')
  static const CartLineStatusEnum BLOCKED = _$cartLineStatusEnum_BLOCKED;

  static Serializer<CartLineStatusEnum> get serializer => _$cartLineStatusEnumSerializer;

  const CartLineStatusEnum._(String name): super(name);

  static BuiltSet<CartLineStatusEnum> get values => _$cartLineStatusEnumValues;
  static CartLineStatusEnum valueOf(String name) => _$cartLineStatusEnumValueOf(name);
}

