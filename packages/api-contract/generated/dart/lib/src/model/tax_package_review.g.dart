// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_package_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxPackageReview extends TaxPackageReview {
  @override
  final int lockVersion;
  @override
  final String actualDueDate;
  @override
  final String dueDateSource;
  @override
  final String reason;
  @override
  final bool reconciled;

  factory _$TaxPackageReview(
          [void Function(TaxPackageReviewBuilder)? updates]) =>
      (TaxPackageReviewBuilder()..update(updates))._build();

  _$TaxPackageReview._(
      {required this.lockVersion,
      required this.actualDueDate,
      required this.dueDateSource,
      required this.reason,
      required this.reconciled})
      : super._();
  @override
  TaxPackageReview rebuild(void Function(TaxPackageReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxPackageReviewBuilder toBuilder() =>
      TaxPackageReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxPackageReview &&
        lockVersion == other.lockVersion &&
        actualDueDate == other.actualDueDate &&
        dueDateSource == other.dueDateSource &&
        reason == other.reason &&
        reconciled == other.reconciled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, actualDueDate.hashCode);
    _$hash = $jc(_$hash, dueDateSource.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, reconciled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxPackageReview')
          ..add('lockVersion', lockVersion)
          ..add('actualDueDate', actualDueDate)
          ..add('dueDateSource', dueDateSource)
          ..add('reason', reason)
          ..add('reconciled', reconciled))
        .toString();
  }
}

class TaxPackageReviewBuilder
    implements Builder<TaxPackageReview, TaxPackageReviewBuilder> {
  _$TaxPackageReview? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _actualDueDate;
  String? get actualDueDate => _$this._actualDueDate;
  set actualDueDate(String? actualDueDate) =>
      _$this._actualDueDate = actualDueDate;

  String? _dueDateSource;
  String? get dueDateSource => _$this._dueDateSource;
  set dueDateSource(String? dueDateSource) =>
      _$this._dueDateSource = dueDateSource;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _reconciled;
  bool? get reconciled => _$this._reconciled;
  set reconciled(bool? reconciled) => _$this._reconciled = reconciled;

  TaxPackageReviewBuilder() {
    TaxPackageReview._defaults(this);
  }

  TaxPackageReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _actualDueDate = $v.actualDueDate;
      _dueDateSource = $v.dueDateSource;
      _reason = $v.reason;
      _reconciled = $v.reconciled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxPackageReview other) {
    _$v = other as _$TaxPackageReview;
  }

  @override
  void update(void Function(TaxPackageReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxPackageReview build() => _build();

  _$TaxPackageReview _build() {
    final _$result = _$v ??
        _$TaxPackageReview._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'TaxPackageReview', 'lockVersion'),
          actualDueDate: BuiltValueNullFieldError.checkNotNull(
              actualDueDate, r'TaxPackageReview', 'actualDueDate'),
          dueDateSource: BuiltValueNullFieldError.checkNotNull(
              dueDateSource, r'TaxPackageReview', 'dueDateSource'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'TaxPackageReview', 'reason'),
          reconciled: BuiltValueNullFieldError.checkNotNull(
              reconciled, r'TaxPackageReview', 'reconciled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
