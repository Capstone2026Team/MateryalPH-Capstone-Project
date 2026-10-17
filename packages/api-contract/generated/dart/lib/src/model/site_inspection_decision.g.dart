// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionDecision extends SiteInspectionDecision {
  @override
  final int lockVersion;
  @override
  final DateTime? scheduledFor;
  @override
  final String? note;
  @override
  final String? reason;
  @override
  final String? measuredVolumeM3;

  factory _$SiteInspectionDecision(
          [void Function(SiteInspectionDecisionBuilder)? updates]) =>
      (SiteInspectionDecisionBuilder()..update(updates))._build();

  _$SiteInspectionDecision._(
      {required this.lockVersion,
      this.scheduledFor,
      this.note,
      this.reason,
      this.measuredVolumeM3})
      : super._();
  @override
  SiteInspectionDecision rebuild(
          void Function(SiteInspectionDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionDecisionBuilder toBuilder() =>
      SiteInspectionDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionDecision &&
        lockVersion == other.lockVersion &&
        scheduledFor == other.scheduledFor &&
        note == other.note &&
        reason == other.reason &&
        measuredVolumeM3 == other.measuredVolumeM3;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, scheduledFor.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, measuredVolumeM3.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionDecision')
          ..add('lockVersion', lockVersion)
          ..add('scheduledFor', scheduledFor)
          ..add('note', note)
          ..add('reason', reason)
          ..add('measuredVolumeM3', measuredVolumeM3))
        .toString();
  }
}

class SiteInspectionDecisionBuilder
    implements Builder<SiteInspectionDecision, SiteInspectionDecisionBuilder> {
  _$SiteInspectionDecision? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  DateTime? _scheduledFor;
  DateTime? get scheduledFor => _$this._scheduledFor;
  set scheduledFor(DateTime? scheduledFor) =>
      _$this._scheduledFor = scheduledFor;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _measuredVolumeM3;
  String? get measuredVolumeM3 => _$this._measuredVolumeM3;
  set measuredVolumeM3(String? measuredVolumeM3) =>
      _$this._measuredVolumeM3 = measuredVolumeM3;

  SiteInspectionDecisionBuilder() {
    SiteInspectionDecision._defaults(this);
  }

  SiteInspectionDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _scheduledFor = $v.scheduledFor;
      _note = $v.note;
      _reason = $v.reason;
      _measuredVolumeM3 = $v.measuredVolumeM3;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionDecision other) {
    _$v = other as _$SiteInspectionDecision;
  }

  @override
  void update(void Function(SiteInspectionDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionDecision build() => _build();

  _$SiteInspectionDecision _build() {
    final _$result = _$v ??
        _$SiteInspectionDecision._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'SiteInspectionDecision', 'lockVersion'),
          scheduledFor: scheduledFor,
          note: note,
          reason: reason,
          measuredVolumeM3: measuredVolumeM3,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
