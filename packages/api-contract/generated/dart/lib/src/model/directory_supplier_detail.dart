//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/provider_attribution.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/google_place_photo.dart';
import 'package:materyalph_api_client/src/model/google_place_attribute.dart';
import 'package:materyalph_api_client/src/model/google_place_review.dart';
import 'package:materyalph_api_client/src/model/google_rating.dart';
import 'package:materyalph_api_client/src/model/google_content_author.dart';
import 'package:materyalph_api_client/src/model/map_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_supplier_detail.g.dart';

/// Informational Tier 1 details. Google photos and review excerpts retain attribution and are never persisted. There is no VPS, verification, listing, message, order, MateryalPH review, payment or storefront field.
///
/// Properties:
/// * [resultId]
/// * [tier]
/// * [tierLabel]
/// * [name]
/// * [formattedAddress]
/// * [marker]
/// * [publicPhone]
/// * [websiteUri]
/// * [googleMapsUri]
/// * [openNow]
/// * [nextCloseTime]
/// * [photos]
/// * [reviews]
/// * [attributes]
/// * [providerAttributions]
/// * [openingHours]
/// * [googleRating]
/// * [attribution]
/// * [fetchedAt]
/// * [actions]
@BuiltValue()
abstract class DirectorySupplierDetail implements Built<DirectorySupplierDetail, DirectorySupplierDetailBuilder> {
  @BuiltValueField(wireName: r'result_id')
  String get resultId;

  @BuiltValueField(wireName: r'tier')
  DirectorySupplierDetailTierEnum get tier;
  // enum tierEnum {  DIRECTORY_SUPPLIER,  };

  @BuiltValueField(wireName: r'tier_label')
  DirectorySupplierDetailTierLabelEnum get tierLabel;
  // enum tierLabelEnum {  Directory Supplier,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'formatted_address')
  String? get formattedAddress;

  @BuiltValueField(wireName: r'marker')
  MapPoint get marker;

  @BuiltValueField(wireName: r'public_phone')
  String? get publicPhone;

  @BuiltValueField(wireName: r'website_uri')
  String? get websiteUri;

  @BuiltValueField(wireName: r'google_maps_uri')
  String? get googleMapsUri;

  @BuiltValueField(wireName: r'open_now')
  bool? get openNow;

  @BuiltValueField(wireName: r'next_close_time')
  DateTime? get nextCloseTime;

  @BuiltValueField(wireName: r'photos')
  BuiltList<GooglePlacePhoto>? get photos;

  @BuiltValueField(wireName: r'reviews')
  BuiltList<GooglePlaceReview>? get reviews;

  @BuiltValueField(wireName: r'attributes')
  BuiltList<GooglePlaceAttribute>? get attributes;

  @BuiltValueField(wireName: r'provider_attributions')
  BuiltList<GoogleContentAuthor>? get providerAttributions;

  @BuiltValueField(wireName: r'opening_hours')
  BuiltList<String> get openingHours;

  @BuiltValueField(wireName: r'google_rating')
  GoogleRating? get googleRating;

  @BuiltValueField(wireName: r'attribution')
  ProviderAttribution get attribution;

  @BuiltValueField(wireName: r'fetched_at')
  DateTime get fetchedAt;

  @BuiltValueField(wireName: r'actions')
  BuiltList<DirectorySupplierDetailActionsEnum> get actions;
  // enum actionsEnum {  CALL,  OPEN_IN_MAPS,  WEBSITE,  SHARE,  };

  DirectorySupplierDetail._();

  factory DirectorySupplierDetail([void updates(DirectorySupplierDetailBuilder b)]) = _$DirectorySupplierDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectorySupplierDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectorySupplierDetail> get serializer => _$DirectorySupplierDetailSerializer();
}

class _$DirectorySupplierDetailSerializer implements PrimitiveSerializer<DirectorySupplierDetail> {
  @override
  final Iterable<Type> types = const [DirectorySupplierDetail, _$DirectorySupplierDetail];

  @override
  final String wireName = r'DirectorySupplierDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectorySupplierDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'result_id';
    yield serializers.serialize(
      object.resultId,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(DirectorySupplierDetailTierEnum),
    );
    yield r'tier_label';
    yield serializers.serialize(
      object.tierLabel,
      specifiedType: const FullType(DirectorySupplierDetailTierLabelEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'formatted_address';
    yield object.formattedAddress == null ? null : serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType.nullable(String),
    );
    yield r'marker';
    yield serializers.serialize(
      object.marker,
      specifiedType: const FullType(MapPoint),
    );
    yield r'public_phone';
    yield object.publicPhone == null ? null : serializers.serialize(
      object.publicPhone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'website_uri';
    yield object.websiteUri == null ? null : serializers.serialize(
      object.websiteUri,
      specifiedType: const FullType.nullable(String),
    );
    yield r'google_maps_uri';
    yield object.googleMapsUri == null ? null : serializers.serialize(
      object.googleMapsUri,
      specifiedType: const FullType.nullable(String),
    );
    if (object.openNow != null) {
      yield r'open_now';
      yield serializers.serialize(
        object.openNow,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.nextCloseTime != null) {
      yield r'next_close_time';
      yield serializers.serialize(
        object.nextCloseTime,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.photos != null) {
      yield r'photos';
      yield serializers.serialize(
        object.photos,
        specifiedType: const FullType(BuiltList, [FullType(GooglePlacePhoto)]),
      );
    }
    if (object.reviews != null) {
      yield r'reviews';
      yield serializers.serialize(
        object.reviews,
        specifiedType: const FullType(BuiltList, [FullType(GooglePlaceReview)]),
      );
    }
    if (object.attributes != null) {
      yield r'attributes';
      yield serializers.serialize(
        object.attributes,
        specifiedType: const FullType(BuiltList, [FullType(GooglePlaceAttribute)]),
      );
    }
    if (object.providerAttributions != null) {
      yield r'provider_attributions';
      yield serializers.serialize(
        object.providerAttributions,
        specifiedType: const FullType(BuiltList, [FullType(GoogleContentAuthor)]),
      );
    }
    yield r'opening_hours';
    yield serializers.serialize(
      object.openingHours,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'google_rating';
    yield object.googleRating == null ? null : serializers.serialize(
      object.googleRating,
      specifiedType: const FullType.nullable(GoogleRating),
    );
    yield r'attribution';
    yield serializers.serialize(
      object.attribution,
      specifiedType: const FullType(ProviderAttribution),
    );
    yield r'fetched_at';
    yield serializers.serialize(
      object.fetchedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actions';
    yield serializers.serialize(
      object.actions,
      specifiedType: const FullType(BuiltList, [FullType(DirectorySupplierDetailActionsEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectorySupplierDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectorySupplierDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'result_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resultId = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectorySupplierDetailTierEnum),
          ) as DirectorySupplierDetailTierEnum;
          result.tier = valueDes;
          break;
        case r'tier_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectorySupplierDetailTierLabelEnum),
          ) as DirectorySupplierDetailTierLabelEnum;
          result.tierLabel = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'formatted_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formattedAddress = valueDes;
          break;
        case r'marker':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MapPoint),
          ) as MapPoint;
          result.marker.replace(valueDes);
          break;
        case r'public_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicPhone = valueDes;
          break;
        case r'website_uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.websiteUri = valueDes;
          break;
        case r'google_maps_uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.googleMapsUri = valueDes;
          break;
        case r'open_now':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.openNow = valueDes;
          break;
        case r'next_close_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.nextCloseTime = valueDes;
          break;
        case r'photos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(GooglePlacePhoto)]),
          ) as BuiltList<GooglePlacePhoto>?;
          if (valueDes == null) continue;
          result.photos.replace(valueDes);
          break;
        case r'reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(GooglePlaceReview)]),
          ) as BuiltList<GooglePlaceReview>?;
          if (valueDes == null) continue;
          result.reviews.replace(valueDes);
          break;
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(GooglePlaceAttribute)]),
          ) as BuiltList<GooglePlaceAttribute>?;
          if (valueDes == null) continue;
          result.attributes.replace(valueDes);
          break;
        case r'provider_attributions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(GoogleContentAuthor)]),
          ) as BuiltList<GoogleContentAuthor>?;
          if (valueDes == null) continue;
          result.providerAttributions.replace(valueDes);
          break;
        case r'opening_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.openingHours.replace(valueDes);
          break;
        case r'google_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GoogleRating),
          ) as GoogleRating?;
          if (valueDes == null) continue;
          result.googleRating.replace(valueDes);
          break;
        case r'attribution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProviderAttribution),
          ) as ProviderAttribution;
          result.attribution.replace(valueDes);
          break;
        case r'fetched_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fetchedAt = valueDes;
          break;
        case r'actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DirectorySupplierDetailActionsEnum)]),
          ) as BuiltList<DirectorySupplierDetailActionsEnum>;
          result.actions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectorySupplierDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectorySupplierDetailBuilder();
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


class DirectorySupplierDetailTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DIRECTORY_SUPPLIER')
  static const DirectorySupplierDetailTierEnum DIRECTORY_SUPPLIER = _$directorySupplierDetailTierEnum_DIRECTORY_SUPPLIER;

  static Serializer<DirectorySupplierDetailTierEnum> get serializer => _$directorySupplierDetailTierEnumSerializer;

  const DirectorySupplierDetailTierEnum._(String name): super(name);

  static BuiltSet<DirectorySupplierDetailTierEnum> get values => _$directorySupplierDetailTierEnumValues;
  static DirectorySupplierDetailTierEnum valueOf(String name) => _$directorySupplierDetailTierEnumValueOf(name);
}

class DirectorySupplierDetailTierLabelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Directory Supplier')
  static const DirectorySupplierDetailTierLabelEnum directorySupplier = _$directorySupplierDetailTierLabelEnum_directorySupplier;

  static Serializer<DirectorySupplierDetailTierLabelEnum> get serializer => _$directorySupplierDetailTierLabelEnumSerializer;

  const DirectorySupplierDetailTierLabelEnum._(String name): super(name);

  static BuiltSet<DirectorySupplierDetailTierLabelEnum> get values => _$directorySupplierDetailTierLabelEnumValues;
  static DirectorySupplierDetailTierLabelEnum valueOf(String name) => _$directorySupplierDetailTierLabelEnumValueOf(name);
}

class DirectorySupplierDetailActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CALL')
  static const DirectorySupplierDetailActionsEnum CALL = _$directorySupplierDetailActionsEnum_CALL;
  @BuiltValueEnumConst(wireName: r'OPEN_IN_MAPS')
  static const DirectorySupplierDetailActionsEnum OPEN_IN_MAPS = _$directorySupplierDetailActionsEnum_OPEN_IN_MAPS;
  @BuiltValueEnumConst(wireName: r'WEBSITE')
  static const DirectorySupplierDetailActionsEnum WEBSITE = _$directorySupplierDetailActionsEnum_WEBSITE;
  @BuiltValueEnumConst(wireName: r'SHARE')
  static const DirectorySupplierDetailActionsEnum SHARE = _$directorySupplierDetailActionsEnum_SHARE;

  static Serializer<DirectorySupplierDetailActionsEnum> get serializer => _$directorySupplierDetailActionsEnumSerializer;

  const DirectorySupplierDetailActionsEnum._(String name): super(name);

  static BuiltSet<DirectorySupplierDetailActionsEnum> get values => _$directorySupplierDetailActionsEnumValues;
  static DirectorySupplierDetailActionsEnum valueOf(String name) => _$directorySupplierDetailActionsEnumValueOf(name);
}

