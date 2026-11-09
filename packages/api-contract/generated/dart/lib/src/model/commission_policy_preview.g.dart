// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_policy_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionPolicyPreview extends CommissionPolicyPreview {
  @override
  final int vendorCount;
  @override
  final int noticeHours;
  @override
  final bool noticeRequired;
  @override
  final int exampleCommissionCentavos;
  @override
  final int monthlyBasisCentavos;
  @override
  final int estimatedMonthlyChangeCentavos;
  @override
  final String volumePeriod;
  @override
  final String? currentTerms;
  @override
  final String newTerms;
  @override
  final String emailSubject;
  @override
  final String emailHtml;

  factory _$CommissionPolicyPreview(
          [void Function(CommissionPolicyPreviewBuilder)? updates]) =>
      (CommissionPolicyPreviewBuilder()..update(updates))._build();

  _$CommissionPolicyPreview._(
      {required this.vendorCount,
      required this.noticeHours,
      required this.noticeRequired,
      required this.exampleCommissionCentavos,
      required this.monthlyBasisCentavos,
      required this.estimatedMonthlyChangeCentavos,
      required this.volumePeriod,
      this.currentTerms,
      required this.newTerms,
      required this.emailSubject,
      required this.emailHtml})
      : super._();
  @override
  CommissionPolicyPreview rebuild(
          void Function(CommissionPolicyPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPolicyPreviewBuilder toBuilder() =>
      CommissionPolicyPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPolicyPreview &&
        vendorCount == other.vendorCount &&
        noticeHours == other.noticeHours &&
        noticeRequired == other.noticeRequired &&
        exampleCommissionCentavos == other.exampleCommissionCentavos &&
        monthlyBasisCentavos == other.monthlyBasisCentavos &&
        estimatedMonthlyChangeCentavos ==
            other.estimatedMonthlyChangeCentavos &&
        volumePeriod == other.volumePeriod &&
        currentTerms == other.currentTerms &&
        newTerms == other.newTerms &&
        emailSubject == other.emailSubject &&
        emailHtml == other.emailHtml;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, noticeHours.hashCode);
    _$hash = $jc(_$hash, noticeRequired.hashCode);
    _$hash = $jc(_$hash, exampleCommissionCentavos.hashCode);
    _$hash = $jc(_$hash, monthlyBasisCentavos.hashCode);
    _$hash = $jc(_$hash, estimatedMonthlyChangeCentavos.hashCode);
    _$hash = $jc(_$hash, volumePeriod.hashCode);
    _$hash = $jc(_$hash, currentTerms.hashCode);
    _$hash = $jc(_$hash, newTerms.hashCode);
    _$hash = $jc(_$hash, emailSubject.hashCode);
    _$hash = $jc(_$hash, emailHtml.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionPolicyPreview')
          ..add('vendorCount', vendorCount)
          ..add('noticeHours', noticeHours)
          ..add('noticeRequired', noticeRequired)
          ..add('exampleCommissionCentavos', exampleCommissionCentavos)
          ..add('monthlyBasisCentavos', monthlyBasisCentavos)
          ..add(
              'estimatedMonthlyChangeCentavos', estimatedMonthlyChangeCentavos)
          ..add('volumePeriod', volumePeriod)
          ..add('currentTerms', currentTerms)
          ..add('newTerms', newTerms)
          ..add('emailSubject', emailSubject)
          ..add('emailHtml', emailHtml))
        .toString();
  }
}

class CommissionPolicyPreviewBuilder
    implements
        Builder<CommissionPolicyPreview, CommissionPolicyPreviewBuilder> {
  _$CommissionPolicyPreview? _$v;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  int? _noticeHours;
  int? get noticeHours => _$this._noticeHours;
  set noticeHours(int? noticeHours) => _$this._noticeHours = noticeHours;

  bool? _noticeRequired;
  bool? get noticeRequired => _$this._noticeRequired;
  set noticeRequired(bool? noticeRequired) =>
      _$this._noticeRequired = noticeRequired;

  int? _exampleCommissionCentavos;
  int? get exampleCommissionCentavos => _$this._exampleCommissionCentavos;
  set exampleCommissionCentavos(int? exampleCommissionCentavos) =>
      _$this._exampleCommissionCentavos = exampleCommissionCentavos;

  int? _monthlyBasisCentavos;
  int? get monthlyBasisCentavos => _$this._monthlyBasisCentavos;
  set monthlyBasisCentavos(int? monthlyBasisCentavos) =>
      _$this._monthlyBasisCentavos = monthlyBasisCentavos;

  int? _estimatedMonthlyChangeCentavos;
  int? get estimatedMonthlyChangeCentavos =>
      _$this._estimatedMonthlyChangeCentavos;
  set estimatedMonthlyChangeCentavos(int? estimatedMonthlyChangeCentavos) =>
      _$this._estimatedMonthlyChangeCentavos = estimatedMonthlyChangeCentavos;

  String? _volumePeriod;
  String? get volumePeriod => _$this._volumePeriod;
  set volumePeriod(String? volumePeriod) => _$this._volumePeriod = volumePeriod;

  String? _currentTerms;
  String? get currentTerms => _$this._currentTerms;
  set currentTerms(String? currentTerms) => _$this._currentTerms = currentTerms;

  String? _newTerms;
  String? get newTerms => _$this._newTerms;
  set newTerms(String? newTerms) => _$this._newTerms = newTerms;

  String? _emailSubject;
  String? get emailSubject => _$this._emailSubject;
  set emailSubject(String? emailSubject) => _$this._emailSubject = emailSubject;

  String? _emailHtml;
  String? get emailHtml => _$this._emailHtml;
  set emailHtml(String? emailHtml) => _$this._emailHtml = emailHtml;

  CommissionPolicyPreviewBuilder() {
    CommissionPolicyPreview._defaults(this);
  }

  CommissionPolicyPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorCount = $v.vendorCount;
      _noticeHours = $v.noticeHours;
      _noticeRequired = $v.noticeRequired;
      _exampleCommissionCentavos = $v.exampleCommissionCentavos;
      _monthlyBasisCentavos = $v.monthlyBasisCentavos;
      _estimatedMonthlyChangeCentavos = $v.estimatedMonthlyChangeCentavos;
      _volumePeriod = $v.volumePeriod;
      _currentTerms = $v.currentTerms;
      _newTerms = $v.newTerms;
      _emailSubject = $v.emailSubject;
      _emailHtml = $v.emailHtml;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionPolicyPreview other) {
    _$v = other as _$CommissionPolicyPreview;
  }

  @override
  void update(void Function(CommissionPolicyPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPolicyPreview build() => _build();

  _$CommissionPolicyPreview _build() {
    final _$result = _$v ??
        _$CommissionPolicyPreview._(
          vendorCount: BuiltValueNullFieldError.checkNotNull(
              vendorCount, r'CommissionPolicyPreview', 'vendorCount'),
          noticeHours: BuiltValueNullFieldError.checkNotNull(
              noticeHours, r'CommissionPolicyPreview', 'noticeHours'),
          noticeRequired: BuiltValueNullFieldError.checkNotNull(
              noticeRequired, r'CommissionPolicyPreview', 'noticeRequired'),
          exampleCommissionCentavos: BuiltValueNullFieldError.checkNotNull(
              exampleCommissionCentavos,
              r'CommissionPolicyPreview',
              'exampleCommissionCentavos'),
          monthlyBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              monthlyBasisCentavos,
              r'CommissionPolicyPreview',
              'monthlyBasisCentavos'),
          estimatedMonthlyChangeCentavos: BuiltValueNullFieldError.checkNotNull(
              estimatedMonthlyChangeCentavos,
              r'CommissionPolicyPreview',
              'estimatedMonthlyChangeCentavos'),
          volumePeriod: BuiltValueNullFieldError.checkNotNull(
              volumePeriod, r'CommissionPolicyPreview', 'volumePeriod'),
          currentTerms: currentTerms,
          newTerms: BuiltValueNullFieldError.checkNotNull(
              newTerms, r'CommissionPolicyPreview', 'newTerms'),
          emailSubject: BuiltValueNullFieldError.checkNotNull(
              emailSubject, r'CommissionPolicyPreview', 'emailSubject'),
          emailHtml: BuiltValueNullFieldError.checkNotNull(
              emailHtml, r'CommissionPolicyPreview', 'emailHtml'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
