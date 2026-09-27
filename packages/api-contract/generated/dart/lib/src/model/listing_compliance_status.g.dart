// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_compliance_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingComplianceStatus _$NOT_REQUIRED =
    const ListingComplianceStatus._('NOT_REQUIRED');
const ListingComplianceStatus _$NOT_SUBMITTED =
    const ListingComplianceStatus._('NOT_SUBMITTED');
const ListingComplianceStatus _$PENDING_ADMIN_REVIEW =
    const ListingComplianceStatus._('PENDING_ADMIN_REVIEW');
const ListingComplianceStatus _$VERIFIED =
    const ListingComplianceStatus._('VERIFIED');
const ListingComplianceStatus _$CHANGES_REQUIRED =
    const ListingComplianceStatus._('CHANGES_REQUIRED');
const ListingComplianceStatus _$REJECTED =
    const ListingComplianceStatus._('REJECTED');

ListingComplianceStatus _$valueOf(String name) {
  switch (name) {
    case 'NOT_REQUIRED':
      return _$NOT_REQUIRED;
    case 'NOT_SUBMITTED':
      return _$NOT_SUBMITTED;
    case 'PENDING_ADMIN_REVIEW':
      return _$PENDING_ADMIN_REVIEW;
    case 'VERIFIED':
      return _$VERIFIED;
    case 'CHANGES_REQUIRED':
      return _$CHANGES_REQUIRED;
    case 'REJECTED':
      return _$REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingComplianceStatus> _$values =
    BuiltSet<ListingComplianceStatus>(const <ListingComplianceStatus>[
  _$NOT_REQUIRED,
  _$NOT_SUBMITTED,
  _$PENDING_ADMIN_REVIEW,
  _$VERIFIED,
  _$CHANGES_REQUIRED,
  _$REJECTED,
]);

class _$ListingComplianceStatusMeta {
  const _$ListingComplianceStatusMeta();
  ListingComplianceStatus get NOT_REQUIRED => _$NOT_REQUIRED;
  ListingComplianceStatus get NOT_SUBMITTED => _$NOT_SUBMITTED;
  ListingComplianceStatus get PENDING_ADMIN_REVIEW => _$PENDING_ADMIN_REVIEW;
  ListingComplianceStatus get VERIFIED => _$VERIFIED;
  ListingComplianceStatus get CHANGES_REQUIRED => _$CHANGES_REQUIRED;
  ListingComplianceStatus get REJECTED => _$REJECTED;
  ListingComplianceStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ListingComplianceStatus> get values => _$values;
}

abstract class _$ListingComplianceStatusMixin {
  // ignore: non_constant_identifier_names
  _$ListingComplianceStatusMeta get ListingComplianceStatus =>
      const _$ListingComplianceStatusMeta();
}

Serializer<ListingComplianceStatus> _$listingComplianceStatusSerializer =
    _$ListingComplianceStatusSerializer();

class _$ListingComplianceStatusSerializer
    implements PrimitiveSerializer<ListingComplianceStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_REQUIRED': 'NOT_REQUIRED',
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
    'VERIFIED': 'VERIFIED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_REQUIRED': 'NOT_REQUIRED',
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
    'VERIFIED': 'VERIFIED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingComplianceStatus];
  @override
  final String wireName = 'ListingComplianceStatus';

  @override
  Object serialize(Serializers serializers, ListingComplianceStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingComplianceStatus deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingComplianceStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
