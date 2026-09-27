// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingStatus _$DRAFT = const ListingStatus._('DRAFT');
const ListingStatus _$PENDING_COMPLIANCE =
    const ListingStatus._('PENDING_COMPLIANCE');
const ListingStatus _$PENDING_ADMIN_REVIEW =
    const ListingStatus._('PENDING_ADMIN_REVIEW');
const ListingStatus _$ACTIVE = const ListingStatus._('ACTIVE');
const ListingStatus _$INACTIVE = const ListingStatus._('INACTIVE');
const ListingStatus _$TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED =
    const ListingStatus._('TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED');
const ListingStatus _$REJECTED = const ListingStatus._('REJECTED');

ListingStatus _$valueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$DRAFT;
    case 'PENDING_COMPLIANCE':
      return _$PENDING_COMPLIANCE;
    case 'PENDING_ADMIN_REVIEW':
      return _$PENDING_ADMIN_REVIEW;
    case 'ACTIVE':
      return _$ACTIVE;
    case 'INACTIVE':
      return _$INACTIVE;
    case 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED':
      return _$TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED;
    case 'REJECTED':
      return _$REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingStatus> _$values =
    BuiltSet<ListingStatus>(const <ListingStatus>[
  _$DRAFT,
  _$PENDING_COMPLIANCE,
  _$PENDING_ADMIN_REVIEW,
  _$ACTIVE,
  _$INACTIVE,
  _$TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED,
  _$REJECTED,
]);

class _$ListingStatusMeta {
  const _$ListingStatusMeta();
  ListingStatus get DRAFT => _$DRAFT;
  ListingStatus get PENDING_COMPLIANCE => _$PENDING_COMPLIANCE;
  ListingStatus get PENDING_ADMIN_REVIEW => _$PENDING_ADMIN_REVIEW;
  ListingStatus get ACTIVE => _$ACTIVE;
  ListingStatus get INACTIVE => _$INACTIVE;
  ListingStatus get TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED =>
      _$TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED;
  ListingStatus get REJECTED => _$REJECTED;
  ListingStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ListingStatus> get values => _$values;
}

abstract class _$ListingStatusMixin {
  // ignore: non_constant_identifier_names
  _$ListingStatusMeta get ListingStatus => const _$ListingStatusMeta();
}

Serializer<ListingStatus> _$listingStatusSerializer =
    _$ListingStatusSerializer();

class _$ListingStatusSerializer implements PrimitiveSerializer<ListingStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'PENDING_COMPLIANCE': 'PENDING_COMPLIANCE',
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
    'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED':
        'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'PENDING_COMPLIANCE': 'PENDING_COMPLIANCE',
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
    'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED':
        'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingStatus];
  @override
  final String wireName = 'ListingStatus';

  @override
  Object serialize(Serializers serializers, ListingStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
