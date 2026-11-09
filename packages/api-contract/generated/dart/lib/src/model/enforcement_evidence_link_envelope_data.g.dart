// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_evidence_link_envelope_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnforcementEvidenceLinkEnvelopeData
    extends EnforcementEvidenceLinkEnvelopeData {
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$EnforcementEvidenceLinkEnvelopeData(
          [void Function(EnforcementEvidenceLinkEnvelopeDataBuilder)?
              updates]) =>
      (EnforcementEvidenceLinkEnvelopeDataBuilder()..update(updates))._build();

  _$EnforcementEvidenceLinkEnvelopeData._(
      {required this.url, required this.expiresAt})
      : super._();
  @override
  EnforcementEvidenceLinkEnvelopeData rebuild(
          void Function(EnforcementEvidenceLinkEnvelopeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementEvidenceLinkEnvelopeDataBuilder toBuilder() =>
      EnforcementEvidenceLinkEnvelopeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementEvidenceLinkEnvelopeData &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementEvidenceLinkEnvelopeData')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class EnforcementEvidenceLinkEnvelopeDataBuilder
    implements
        Builder<EnforcementEvidenceLinkEnvelopeData,
            EnforcementEvidenceLinkEnvelopeDataBuilder> {
  _$EnforcementEvidenceLinkEnvelopeData? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  EnforcementEvidenceLinkEnvelopeDataBuilder() {
    EnforcementEvidenceLinkEnvelopeData._defaults(this);
  }

  EnforcementEvidenceLinkEnvelopeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnforcementEvidenceLinkEnvelopeData other) {
    _$v = other as _$EnforcementEvidenceLinkEnvelopeData;
  }

  @override
  void update(
      void Function(EnforcementEvidenceLinkEnvelopeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementEvidenceLinkEnvelopeData build() => _build();

  _$EnforcementEvidenceLinkEnvelopeData _build() {
    final _$result = _$v ??
        _$EnforcementEvidenceLinkEnvelopeData._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'EnforcementEvidenceLinkEnvelopeData', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'EnforcementEvidenceLinkEnvelopeData', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
