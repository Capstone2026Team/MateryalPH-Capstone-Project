// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stale_listing.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StaleListing extends StaleListing {
  @override
  final String listingId;
  @override
  final String listingName;
  @override
  final ListingStatus listingStatus;
  @override
  final StockConfirmationSchedule confirmation;

  factory _$StaleListing([void Function(StaleListingBuilder)? updates]) =>
      (StaleListingBuilder()..update(updates))._build();

  _$StaleListing._(
      {required this.listingId,
      required this.listingName,
      required this.listingStatus,
      required this.confirmation})
      : super._();
  @override
  StaleListing rebuild(void Function(StaleListingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StaleListingBuilder toBuilder() => StaleListingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StaleListing &&
        listingId == other.listingId &&
        listingName == other.listingName &&
        listingStatus == other.listingStatus &&
        confirmation == other.confirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, listingName.hashCode);
    _$hash = $jc(_$hash, listingStatus.hashCode);
    _$hash = $jc(_$hash, confirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StaleListing')
          ..add('listingId', listingId)
          ..add('listingName', listingName)
          ..add('listingStatus', listingStatus)
          ..add('confirmation', confirmation))
        .toString();
  }
}

class StaleListingBuilder
    implements Builder<StaleListing, StaleListingBuilder> {
  _$StaleListing? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _listingName;
  String? get listingName => _$this._listingName;
  set listingName(String? listingName) => _$this._listingName = listingName;

  ListingStatus? _listingStatus;
  ListingStatus? get listingStatus => _$this._listingStatus;
  set listingStatus(ListingStatus? listingStatus) =>
      _$this._listingStatus = listingStatus;

  StockConfirmationScheduleBuilder? _confirmation;
  StockConfirmationScheduleBuilder get confirmation =>
      _$this._confirmation ??= StockConfirmationScheduleBuilder();
  set confirmation(StockConfirmationScheduleBuilder? confirmation) =>
      _$this._confirmation = confirmation;

  StaleListingBuilder() {
    StaleListing._defaults(this);
  }

  StaleListingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _listingName = $v.listingName;
      _listingStatus = $v.listingStatus;
      _confirmation = $v.confirmation.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StaleListing other) {
    _$v = other as _$StaleListing;
  }

  @override
  void update(void Function(StaleListingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StaleListing build() => _build();

  _$StaleListing _build() {
    _$StaleListing _$result;
    try {
      _$result = _$v ??
          _$StaleListing._(
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'StaleListing', 'listingId'),
            listingName: BuiltValueNullFieldError.checkNotNull(
                listingName, r'StaleListing', 'listingName'),
            listingStatus: BuiltValueNullFieldError.checkNotNull(
                listingStatus, r'StaleListing', 'listingStatus'),
            confirmation: confirmation.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'confirmation';
        confirmation.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StaleListing', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
