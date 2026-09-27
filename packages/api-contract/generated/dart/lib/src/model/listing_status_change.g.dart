// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_status_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingStatusChange extends ListingStatusChange {
  @override
  final String? fromStatus;
  @override
  final String toStatus;
  @override
  final String source_;
  @override
  final String? reasonCode;
  @override
  final String? reason;
  @override
  final int? publicationVersion;
  @override
  final String? createdAt;

  factory _$ListingStatusChange(
          [void Function(ListingStatusChangeBuilder)? updates]) =>
      (ListingStatusChangeBuilder()..update(updates))._build();

  _$ListingStatusChange._(
      {this.fromStatus,
      required this.toStatus,
      required this.source_,
      this.reasonCode,
      this.reason,
      this.publicationVersion,
      this.createdAt})
      : super._();
  @override
  ListingStatusChange rebuild(
          void Function(ListingStatusChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingStatusChangeBuilder toBuilder() =>
      ListingStatusChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingStatusChange &&
        fromStatus == other.fromStatus &&
        toStatus == other.toStatus &&
        source_ == other.source_ &&
        reasonCode == other.reasonCode &&
        reason == other.reason &&
        publicationVersion == other.publicationVersion &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fromStatus.hashCode);
    _$hash = $jc(_$hash, toStatus.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, publicationVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingStatusChange')
          ..add('fromStatus', fromStatus)
          ..add('toStatus', toStatus)
          ..add('source_', source_)
          ..add('reasonCode', reasonCode)
          ..add('reason', reason)
          ..add('publicationVersion', publicationVersion)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ListingStatusChangeBuilder
    implements Builder<ListingStatusChange, ListingStatusChangeBuilder> {
  _$ListingStatusChange? _$v;

  String? _fromStatus;
  String? get fromStatus => _$this._fromStatus;
  set fromStatus(String? fromStatus) => _$this._fromStatus = fromStatus;

  String? _toStatus;
  String? get toStatus => _$this._toStatus;
  set toStatus(String? toStatus) => _$this._toStatus = toStatus;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _publicationVersion;
  int? get publicationVersion => _$this._publicationVersion;
  set publicationVersion(int? publicationVersion) =>
      _$this._publicationVersion = publicationVersion;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  ListingStatusChangeBuilder() {
    ListingStatusChange._defaults(this);
  }

  ListingStatusChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fromStatus = $v.fromStatus;
      _toStatus = $v.toStatus;
      _source_ = $v.source_;
      _reasonCode = $v.reasonCode;
      _reason = $v.reason;
      _publicationVersion = $v.publicationVersion;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingStatusChange other) {
    _$v = other as _$ListingStatusChange;
  }

  @override
  void update(void Function(ListingStatusChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingStatusChange build() => _build();

  _$ListingStatusChange _build() {
    final _$result = _$v ??
        _$ListingStatusChange._(
          fromStatus: fromStatus,
          toStatus: BuiltValueNullFieldError.checkNotNull(
              toStatus, r'ListingStatusChange', 'toStatus'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'ListingStatusChange', 'source_'),
          reasonCode: reasonCode,
          reason: reason,
          publicationVersion: publicationVersion,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
