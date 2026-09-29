//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/score_label.dart';
import 'package:materyalph_api_client/src/model/supplier_open_status.dart';
import 'package:materyalph_api_client/src/model/public_address_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_detail_vendor.g.dart';

/// ListingDetailVendor
///
/// Properties:
/// * [id]
/// * [name]
/// * [logoUrl]
/// * [scoreLabel]
/// * [address]
/// * [openStatus]
/// * [vacationMode]
/// * [supplierType]
@BuiltValue()
abstract class ListingDetailVendor implements Built<ListingDetailVendor, ListingDetailVendorBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'logo_url')
  String? get logoUrl;

  @BuiltValueField(wireName: r'score_label')
  ScoreLabel get scoreLabel;

  @BuiltValueField(wireName: r'address')
  PublicAddressSummary get address;

  @BuiltValueField(wireName: r'open_status')
  SupplierOpenStatus get openStatus;

  @BuiltValueField(wireName: r'vacation_mode')
  bool get vacationMode;

  @BuiltValueField(wireName: r'supplier_type')
  String? get supplierType;

  ListingDetailVendor._();

  factory ListingDetailVendor([void updates(ListingDetailVendorBuilder b)]) = _$ListingDetailVendor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingDetailVendorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingDetailVendor> get serializer => _$ListingDetailVendorSerializer();
}

class _$ListingDetailVendorSerializer implements PrimitiveSerializer<ListingDetailVendor> {
  @override
  final Iterable<Type> types = const [ListingDetailVendor, _$ListingDetailVendor];

  @override
  final String wireName = r'ListingDetailVendor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingDetailVendor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'logo_url';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'score_label';
    yield serializers.serialize(
      object.scoreLabel,
      specifiedType: const FullType(ScoreLabel),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(PublicAddressSummary),
    );
    yield r'open_status';
    yield serializers.serialize(
      object.openStatus,
      specifiedType: const FullType(SupplierOpenStatus),
    );
    yield r'vacation_mode';
    yield serializers.serialize(
      object.vacationMode,
      specifiedType: const FullType(bool),
    );
    yield r'supplier_type';
    yield object.supplierType == null ? null : serializers.serialize(
      object.supplierType,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingDetailVendor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingDetailVendorBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'logo_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'score_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScoreLabel),
          ) as ScoreLabel;
          result.scoreLabel.replace(valueDes);
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicAddressSummary),
          ) as PublicAddressSummary;
          result.address.replace(valueDes);
          break;
        case r'open_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierOpenStatus),
          ) as SupplierOpenStatus;
          result.openStatus.replace(valueDes);
          break;
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vacationMode = valueDes;
          break;
        case r'supplier_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supplierType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingDetailVendor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingDetailVendorBuilder();
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


