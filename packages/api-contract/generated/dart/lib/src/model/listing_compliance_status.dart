//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_compliance_status.g.dart';

class ListingComplianceStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_REQUIRED')
  static const ListingComplianceStatus NOT_REQUIRED = _$NOT_REQUIRED;
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const ListingComplianceStatus NOT_SUBMITTED = _$NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_ADMIN_REVIEW')
  static const ListingComplianceStatus PENDING_ADMIN_REVIEW = _$PENDING_ADMIN_REVIEW;
  @BuiltValueEnumConst(wireName: r'VERIFIED')
  static const ListingComplianceStatus VERIFIED = _$VERIFIED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const ListingComplianceStatus CHANGES_REQUIRED = _$CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ListingComplianceStatus REJECTED = _$REJECTED;

  static Serializer<ListingComplianceStatus> get serializer => _$listingComplianceStatusSerializer;

  const ListingComplianceStatus._(String name): super(name);

  static BuiltSet<ListingComplianceStatus> get values => _$values;
  static ListingComplianceStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ListingComplianceStatusMixin = Object with _$ListingComplianceStatusMixin;

