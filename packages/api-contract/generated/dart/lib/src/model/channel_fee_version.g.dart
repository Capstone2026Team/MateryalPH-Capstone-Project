// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_fee_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChannelFeeVersion extends ChannelFeeVersion {
  @override
  final String code;
  @override
  final String displayName;
  @override
  final String kind;
  @override
  final int version;
  @override
  final int ratePpm;
  @override
  final int fixedCentavos;
  @override
  final int feeVatBasisPoints;
  @override
  final bool rateIncludesVat;
  @override
  final bool refundSupported;
  @override
  final bool enabled;
  @override
  final String? disabledReason;
  @override
  final String sourceType;
  @override
  final String sourceReference;
  @override
  final DateTime? effectiveFrom;

  factory _$ChannelFeeVersion(
          [void Function(ChannelFeeVersionBuilder)? updates]) =>
      (ChannelFeeVersionBuilder()..update(updates))._build();

  _$ChannelFeeVersion._(
      {required this.code,
      required this.displayName,
      required this.kind,
      required this.version,
      required this.ratePpm,
      required this.fixedCentavos,
      required this.feeVatBasisPoints,
      required this.rateIncludesVat,
      required this.refundSupported,
      required this.enabled,
      this.disabledReason,
      required this.sourceType,
      required this.sourceReference,
      this.effectiveFrom})
      : super._();
  @override
  ChannelFeeVersion rebuild(void Function(ChannelFeeVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelFeeVersionBuilder toBuilder() =>
      ChannelFeeVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelFeeVersion &&
        code == other.code &&
        displayName == other.displayName &&
        kind == other.kind &&
        version == other.version &&
        ratePpm == other.ratePpm &&
        fixedCentavos == other.fixedCentavos &&
        feeVatBasisPoints == other.feeVatBasisPoints &&
        rateIncludesVat == other.rateIncludesVat &&
        refundSupported == other.refundSupported &&
        enabled == other.enabled &&
        disabledReason == other.disabledReason &&
        sourceType == other.sourceType &&
        sourceReference == other.sourceReference &&
        effectiveFrom == other.effectiveFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, ratePpm.hashCode);
    _$hash = $jc(_$hash, fixedCentavos.hashCode);
    _$hash = $jc(_$hash, feeVatBasisPoints.hashCode);
    _$hash = $jc(_$hash, rateIncludesVat.hashCode);
    _$hash = $jc(_$hash, refundSupported.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, disabledReason.hashCode);
    _$hash = $jc(_$hash, sourceType.hashCode);
    _$hash = $jc(_$hash, sourceReference.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChannelFeeVersion')
          ..add('code', code)
          ..add('displayName', displayName)
          ..add('kind', kind)
          ..add('version', version)
          ..add('ratePpm', ratePpm)
          ..add('fixedCentavos', fixedCentavos)
          ..add('feeVatBasisPoints', feeVatBasisPoints)
          ..add('rateIncludesVat', rateIncludesVat)
          ..add('refundSupported', refundSupported)
          ..add('enabled', enabled)
          ..add('disabledReason', disabledReason)
          ..add('sourceType', sourceType)
          ..add('sourceReference', sourceReference)
          ..add('effectiveFrom', effectiveFrom))
        .toString();
  }
}

class ChannelFeeVersionBuilder
    implements Builder<ChannelFeeVersion, ChannelFeeVersionBuilder> {
  _$ChannelFeeVersion? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  int? _ratePpm;
  int? get ratePpm => _$this._ratePpm;
  set ratePpm(int? ratePpm) => _$this._ratePpm = ratePpm;

  int? _fixedCentavos;
  int? get fixedCentavos => _$this._fixedCentavos;
  set fixedCentavos(int? fixedCentavos) =>
      _$this._fixedCentavos = fixedCentavos;

  int? _feeVatBasisPoints;
  int? get feeVatBasisPoints => _$this._feeVatBasisPoints;
  set feeVatBasisPoints(int? feeVatBasisPoints) =>
      _$this._feeVatBasisPoints = feeVatBasisPoints;

  bool? _rateIncludesVat;
  bool? get rateIncludesVat => _$this._rateIncludesVat;
  set rateIncludesVat(bool? rateIncludesVat) =>
      _$this._rateIncludesVat = rateIncludesVat;

  bool? _refundSupported;
  bool? get refundSupported => _$this._refundSupported;
  set refundSupported(bool? refundSupported) =>
      _$this._refundSupported = refundSupported;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _disabledReason;
  String? get disabledReason => _$this._disabledReason;
  set disabledReason(String? disabledReason) =>
      _$this._disabledReason = disabledReason;

  String? _sourceType;
  String? get sourceType => _$this._sourceType;
  set sourceType(String? sourceType) => _$this._sourceType = sourceType;

  String? _sourceReference;
  String? get sourceReference => _$this._sourceReference;
  set sourceReference(String? sourceReference) =>
      _$this._sourceReference = sourceReference;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  ChannelFeeVersionBuilder() {
    ChannelFeeVersion._defaults(this);
  }

  ChannelFeeVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _displayName = $v.displayName;
      _kind = $v.kind;
      _version = $v.version;
      _ratePpm = $v.ratePpm;
      _fixedCentavos = $v.fixedCentavos;
      _feeVatBasisPoints = $v.feeVatBasisPoints;
      _rateIncludesVat = $v.rateIncludesVat;
      _refundSupported = $v.refundSupported;
      _enabled = $v.enabled;
      _disabledReason = $v.disabledReason;
      _sourceType = $v.sourceType;
      _sourceReference = $v.sourceReference;
      _effectiveFrom = $v.effectiveFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelFeeVersion other) {
    _$v = other as _$ChannelFeeVersion;
  }

  @override
  void update(void Function(ChannelFeeVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChannelFeeVersion build() => _build();

  _$ChannelFeeVersion _build() {
    final _$result = _$v ??
        _$ChannelFeeVersion._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ChannelFeeVersion', 'code'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ChannelFeeVersion', 'displayName'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'ChannelFeeVersion', 'kind'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'ChannelFeeVersion', 'version'),
          ratePpm: BuiltValueNullFieldError.checkNotNull(
              ratePpm, r'ChannelFeeVersion', 'ratePpm'),
          fixedCentavos: BuiltValueNullFieldError.checkNotNull(
              fixedCentavos, r'ChannelFeeVersion', 'fixedCentavos'),
          feeVatBasisPoints: BuiltValueNullFieldError.checkNotNull(
              feeVatBasisPoints, r'ChannelFeeVersion', 'feeVatBasisPoints'),
          rateIncludesVat: BuiltValueNullFieldError.checkNotNull(
              rateIncludesVat, r'ChannelFeeVersion', 'rateIncludesVat'),
          refundSupported: BuiltValueNullFieldError.checkNotNull(
              refundSupported, r'ChannelFeeVersion', 'refundSupported'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'ChannelFeeVersion', 'enabled'),
          disabledReason: disabledReason,
          sourceType: BuiltValueNullFieldError.checkNotNull(
              sourceType, r'ChannelFeeVersion', 'sourceType'),
          sourceReference: BuiltValueNullFieldError.checkNotNull(
              sourceReference, r'ChannelFeeVersion', 'sourceReference'),
          effectiveFrom: effectiveFrom,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
