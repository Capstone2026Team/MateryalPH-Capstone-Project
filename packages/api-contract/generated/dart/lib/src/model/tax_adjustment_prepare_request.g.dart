// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_adjustment_prepare_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaxAdjustmentPrepareRequestCertificateImpactEnum
    _$taxAdjustmentPrepareRequestCertificateImpactEnum_NONE =
    const TaxAdjustmentPrepareRequestCertificateImpactEnum._('NONE');
const TaxAdjustmentPrepareRequestCertificateImpactEnum
    _$taxAdjustmentPrepareRequestCertificateImpactEnum_REISSUE_REQUIRED =
    const TaxAdjustmentPrepareRequestCertificateImpactEnum._(
        'REISSUE_REQUIRED');
const TaxAdjustmentPrepareRequestCertificateImpactEnum
    _$taxAdjustmentPrepareRequestCertificateImpactEnum_AMENDMENT_REQUIRED =
    const TaxAdjustmentPrepareRequestCertificateImpactEnum._(
        'AMENDMENT_REQUIRED');

TaxAdjustmentPrepareRequestCertificateImpactEnum
    _$taxAdjustmentPrepareRequestCertificateImpactEnumValueOf(String name) {
  switch (name) {
    case 'NONE':
      return _$taxAdjustmentPrepareRequestCertificateImpactEnum_NONE;
    case 'REISSUE_REQUIRED':
      return _$taxAdjustmentPrepareRequestCertificateImpactEnum_REISSUE_REQUIRED;
    case 'AMENDMENT_REQUIRED':
      return _$taxAdjustmentPrepareRequestCertificateImpactEnum_AMENDMENT_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxAdjustmentPrepareRequestCertificateImpactEnum>
    _$taxAdjustmentPrepareRequestCertificateImpactEnumValues = BuiltSet<
        TaxAdjustmentPrepareRequestCertificateImpactEnum>(const <TaxAdjustmentPrepareRequestCertificateImpactEnum>[
  _$taxAdjustmentPrepareRequestCertificateImpactEnum_NONE,
  _$taxAdjustmentPrepareRequestCertificateImpactEnum_REISSUE_REQUIRED,
  _$taxAdjustmentPrepareRequestCertificateImpactEnum_AMENDMENT_REQUIRED,
]);

Serializer<TaxAdjustmentPrepareRequestCertificateImpactEnum>
    _$taxAdjustmentPrepareRequestCertificateImpactEnumSerializer =
    _$TaxAdjustmentPrepareRequestCertificateImpactEnumSerializer();

class _$TaxAdjustmentPrepareRequestCertificateImpactEnumSerializer
    implements
        PrimitiveSerializer<TaxAdjustmentPrepareRequestCertificateImpactEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NONE': 'NONE',
    'REISSUE_REQUIRED': 'REISSUE_REQUIRED',
    'AMENDMENT_REQUIRED': 'AMENDMENT_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NONE': 'NONE',
    'REISSUE_REQUIRED': 'REISSUE_REQUIRED',
    'AMENDMENT_REQUIRED': 'AMENDMENT_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TaxAdjustmentPrepareRequestCertificateImpactEnum
  ];
  @override
  final String wireName = 'TaxAdjustmentPrepareRequestCertificateImpactEnum';

  @override
  Object serialize(Serializers serializers,
          TaxAdjustmentPrepareRequestCertificateImpactEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxAdjustmentPrepareRequestCertificateImpactEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxAdjustmentPrepareRequestCertificateImpactEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaxAdjustmentPrepareRequest extends TaxAdjustmentPrepareRequest {
  @override
  final int correctedWithheldCentavos;
  @override
  final String reason;
  @override
  final TaxAdjustmentPrepareRequestCertificateImpactEnum certificateImpact;
  @override
  final String? evidenceReference;

  factory _$TaxAdjustmentPrepareRequest(
          [void Function(TaxAdjustmentPrepareRequestBuilder)? updates]) =>
      (TaxAdjustmentPrepareRequestBuilder()..update(updates))._build();

  _$TaxAdjustmentPrepareRequest._(
      {required this.correctedWithheldCentavos,
      required this.reason,
      required this.certificateImpact,
      this.evidenceReference})
      : super._();
  @override
  TaxAdjustmentPrepareRequest rebuild(
          void Function(TaxAdjustmentPrepareRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxAdjustmentPrepareRequestBuilder toBuilder() =>
      TaxAdjustmentPrepareRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxAdjustmentPrepareRequest &&
        correctedWithheldCentavos == other.correctedWithheldCentavos &&
        reason == other.reason &&
        certificateImpact == other.certificateImpact &&
        evidenceReference == other.evidenceReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, correctedWithheldCentavos.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, certificateImpact.hashCode);
    _$hash = $jc(_$hash, evidenceReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxAdjustmentPrepareRequest')
          ..add('correctedWithheldCentavos', correctedWithheldCentavos)
          ..add('reason', reason)
          ..add('certificateImpact', certificateImpact)
          ..add('evidenceReference', evidenceReference))
        .toString();
  }
}

class TaxAdjustmentPrepareRequestBuilder
    implements
        Builder<TaxAdjustmentPrepareRequest,
            TaxAdjustmentPrepareRequestBuilder> {
  _$TaxAdjustmentPrepareRequest? _$v;

  int? _correctedWithheldCentavos;
  int? get correctedWithheldCentavos => _$this._correctedWithheldCentavos;
  set correctedWithheldCentavos(int? correctedWithheldCentavos) =>
      _$this._correctedWithheldCentavos = correctedWithheldCentavos;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  TaxAdjustmentPrepareRequestCertificateImpactEnum? _certificateImpact;
  TaxAdjustmentPrepareRequestCertificateImpactEnum? get certificateImpact =>
      _$this._certificateImpact;
  set certificateImpact(
          TaxAdjustmentPrepareRequestCertificateImpactEnum?
              certificateImpact) =>
      _$this._certificateImpact = certificateImpact;

  String? _evidenceReference;
  String? get evidenceReference => _$this._evidenceReference;
  set evidenceReference(String? evidenceReference) =>
      _$this._evidenceReference = evidenceReference;

  TaxAdjustmentPrepareRequestBuilder() {
    TaxAdjustmentPrepareRequest._defaults(this);
  }

  TaxAdjustmentPrepareRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _correctedWithheldCentavos = $v.correctedWithheldCentavos;
      _reason = $v.reason;
      _certificateImpact = $v.certificateImpact;
      _evidenceReference = $v.evidenceReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxAdjustmentPrepareRequest other) {
    _$v = other as _$TaxAdjustmentPrepareRequest;
  }

  @override
  void update(void Function(TaxAdjustmentPrepareRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxAdjustmentPrepareRequest build() => _build();

  _$TaxAdjustmentPrepareRequest _build() {
    final _$result = _$v ??
        _$TaxAdjustmentPrepareRequest._(
          correctedWithheldCentavos: BuiltValueNullFieldError.checkNotNull(
              correctedWithheldCentavos,
              r'TaxAdjustmentPrepareRequest',
              'correctedWithheldCentavos'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'TaxAdjustmentPrepareRequest', 'reason'),
          certificateImpact: BuiltValueNullFieldError.checkNotNull(
              certificateImpact,
              r'TaxAdjustmentPrepareRequest',
              'certificateImpact'),
          evidenceReference: evidenceReference,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
