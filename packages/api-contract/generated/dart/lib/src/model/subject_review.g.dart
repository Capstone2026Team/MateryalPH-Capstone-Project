// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class SubjectReviewBuilder {
  void replace(SubjectReview other);
  void update(void Function(SubjectReviewBuilder) updates);
  String? get subjectType;
  set subjectType(String? subjectType);

  String? get subjectId;
  set subjectId(String? subjectId);

  String? get displayName;
  set displayName(String? displayName);

  String? get maskedEmail;
  set maskedEmail(String? maskedEmail);

  String? get accountStatus;
  set accountStatus(String? accountStatus);

  String? get storeActivationStatus;
  set storeActivationStatus(String? storeActivationStatus);

  int? get openOrders;
  set openOrders(int? openOrders);

  int? get ordersTotal;
  set ordersTotal(int? ordersTotal);

  int? get disputesTotal;
  set disputesTotal(int? disputesTotal);

  int? get disputesOpen;
  set disputesOpen(int? disputesOpen);

  DateTime? get commerceRestrictedUntil;
  set commerceRestrictedUntil(DateTime? commerceRestrictedUntil);
}

class _$$SubjectReview extends $SubjectReview {
  @override
  final String? subjectType;
  @override
  final String? subjectId;
  @override
  final String? displayName;
  @override
  final String? maskedEmail;
  @override
  final String? accountStatus;
  @override
  final String? storeActivationStatus;
  @override
  final int? openOrders;
  @override
  final int? ordersTotal;
  @override
  final int? disputesTotal;
  @override
  final int? disputesOpen;
  @override
  final DateTime? commerceRestrictedUntil;

  factory _$$SubjectReview([void Function($SubjectReviewBuilder)? updates]) =>
      ($SubjectReviewBuilder()..update(updates))._build();

  _$$SubjectReview._(
      {this.subjectType,
      this.subjectId,
      this.displayName,
      this.maskedEmail,
      this.accountStatus,
      this.storeActivationStatus,
      this.openOrders,
      this.ordersTotal,
      this.disputesTotal,
      this.disputesOpen,
      this.commerceRestrictedUntil})
      : super._();
  @override
  $SubjectReview rebuild(void Function($SubjectReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $SubjectReviewBuilder toBuilder() => $SubjectReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $SubjectReview &&
        subjectType == other.subjectType &&
        subjectId == other.subjectId &&
        displayName == other.displayName &&
        maskedEmail == other.maskedEmail &&
        accountStatus == other.accountStatus &&
        storeActivationStatus == other.storeActivationStatus &&
        openOrders == other.openOrders &&
        ordersTotal == other.ordersTotal &&
        disputesTotal == other.disputesTotal &&
        disputesOpen == other.disputesOpen &&
        commerceRestrictedUntil == other.commerceRestrictedUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subjectType.hashCode);
    _$hash = $jc(_$hash, subjectId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, maskedEmail.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, storeActivationStatus.hashCode);
    _$hash = $jc(_$hash, openOrders.hashCode);
    _$hash = $jc(_$hash, ordersTotal.hashCode);
    _$hash = $jc(_$hash, disputesTotal.hashCode);
    _$hash = $jc(_$hash, disputesOpen.hashCode);
    _$hash = $jc(_$hash, commerceRestrictedUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$SubjectReview')
          ..add('subjectType', subjectType)
          ..add('subjectId', subjectId)
          ..add('displayName', displayName)
          ..add('maskedEmail', maskedEmail)
          ..add('accountStatus', accountStatus)
          ..add('storeActivationStatus', storeActivationStatus)
          ..add('openOrders', openOrders)
          ..add('ordersTotal', ordersTotal)
          ..add('disputesTotal', disputesTotal)
          ..add('disputesOpen', disputesOpen)
          ..add('commerceRestrictedUntil', commerceRestrictedUntil))
        .toString();
  }
}

class $SubjectReviewBuilder
    implements
        Builder<$SubjectReview, $SubjectReviewBuilder>,
        SubjectReviewBuilder {
  _$$SubjectReview? _$v;

  String? _subjectType;
  String? get subjectType => _$this._subjectType;
  set subjectType(covariant String? subjectType) =>
      _$this._subjectType = subjectType;

  String? _subjectId;
  String? get subjectId => _$this._subjectId;
  set subjectId(covariant String? subjectId) => _$this._subjectId = subjectId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(covariant String? displayName) =>
      _$this._displayName = displayName;

  String? _maskedEmail;
  String? get maskedEmail => _$this._maskedEmail;
  set maskedEmail(covariant String? maskedEmail) =>
      _$this._maskedEmail = maskedEmail;

  String? _accountStatus;
  String? get accountStatus => _$this._accountStatus;
  set accountStatus(covariant String? accountStatus) =>
      _$this._accountStatus = accountStatus;

  String? _storeActivationStatus;
  String? get storeActivationStatus => _$this._storeActivationStatus;
  set storeActivationStatus(covariant String? storeActivationStatus) =>
      _$this._storeActivationStatus = storeActivationStatus;

  int? _openOrders;
  int? get openOrders => _$this._openOrders;
  set openOrders(covariant int? openOrders) => _$this._openOrders = openOrders;

  int? _ordersTotal;
  int? get ordersTotal => _$this._ordersTotal;
  set ordersTotal(covariant int? ordersTotal) =>
      _$this._ordersTotal = ordersTotal;

  int? _disputesTotal;
  int? get disputesTotal => _$this._disputesTotal;
  set disputesTotal(covariant int? disputesTotal) =>
      _$this._disputesTotal = disputesTotal;

  int? _disputesOpen;
  int? get disputesOpen => _$this._disputesOpen;
  set disputesOpen(covariant int? disputesOpen) =>
      _$this._disputesOpen = disputesOpen;

  DateTime? _commerceRestrictedUntil;
  DateTime? get commerceRestrictedUntil => _$this._commerceRestrictedUntil;
  set commerceRestrictedUntil(covariant DateTime? commerceRestrictedUntil) =>
      _$this._commerceRestrictedUntil = commerceRestrictedUntil;

  $SubjectReviewBuilder() {
    $SubjectReview._defaults(this);
  }

  $SubjectReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subjectType = $v.subjectType;
      _subjectId = $v.subjectId;
      _displayName = $v.displayName;
      _maskedEmail = $v.maskedEmail;
      _accountStatus = $v.accountStatus;
      _storeActivationStatus = $v.storeActivationStatus;
      _openOrders = $v.openOrders;
      _ordersTotal = $v.ordersTotal;
      _disputesTotal = $v.disputesTotal;
      _disputesOpen = $v.disputesOpen;
      _commerceRestrictedUntil = $v.commerceRestrictedUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $SubjectReview other) {
    _$v = other as _$$SubjectReview;
  }

  @override
  void update(void Function($SubjectReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $SubjectReview build() => _build();

  _$$SubjectReview _build() {
    final _$result = _$v ??
        _$$SubjectReview._(
          subjectType: subjectType,
          subjectId: subjectId,
          displayName: displayName,
          maskedEmail: maskedEmail,
          accountStatus: accountStatus,
          storeActivationStatus: storeActivationStatus,
          openOrders: openOrders,
          ordersTotal: ordersTotal,
          disputesTotal: disputesTotal,
          disputesOpen: disputesOpen,
          commerceRestrictedUntil: commerceRestrictedUntil,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
