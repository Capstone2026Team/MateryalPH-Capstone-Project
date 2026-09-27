//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_status.g.dart';

/// Vendor Workflow listing states. TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED is set by the Phase 5 stale-stock rule.
class ListingStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const ListingStatus DRAFT = _$DRAFT;
  @BuiltValueEnumConst(wireName: r'PENDING_COMPLIANCE')
  static const ListingStatus PENDING_COMPLIANCE = _$PENDING_COMPLIANCE;
  @BuiltValueEnumConst(wireName: r'PENDING_ADMIN_REVIEW')
  static const ListingStatus PENDING_ADMIN_REVIEW = _$PENDING_ADMIN_REVIEW;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ListingStatus ACTIVE = _$ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const ListingStatus INACTIVE = _$INACTIVE;
  @BuiltValueEnumConst(wireName: r'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED')
  static const ListingStatus TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED = _$TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ListingStatus REJECTED = _$REJECTED;

  static Serializer<ListingStatus> get serializer => _$listingStatusSerializer;

  const ListingStatus._(String name): super(name);

  static BuiltSet<ListingStatus> get values => _$values;
  static ListingStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ListingStatusMixin = Object with _$ListingStatusMixin;

