// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_evidence_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxEvidenceRow extends TaxEvidenceRow {
  @override
  final String id;
  @override
  final String evidenceType;
  @override
  final String origin;
  @override
  final Date? validFrom;
  @override
  final Date? validUntil;
  @override
  final String reviewState;
  @override
  final DateTime? reviewedAt;
  @override
  final int taxProfileVersion;
  @override
  final int? taxableYear;
  @override
  final GeoDemandColumnsInner vendor;
  @override
  final String decisionHref;
  @override
  final DateTime createdAt;
  @override
  final String note;

  factory _$TaxEvidenceRow([void Function(TaxEvidenceRowBuilder)? updates]) =>
      (TaxEvidenceRowBuilder()..update(updates))._build();

  _$TaxEvidenceRow._(
      {required this.id,
      required this.evidenceType,
      required this.origin,
      this.validFrom,
      this.validUntil,
      required this.reviewState,
      this.reviewedAt,
      required this.taxProfileVersion,
      this.taxableYear,
      required this.vendor,
      required this.decisionHref,
      required this.createdAt,
      required this.note})
      : super._();
  @override
  TaxEvidenceRow rebuild(void Function(TaxEvidenceRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxEvidenceRowBuilder toBuilder() => TaxEvidenceRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxEvidenceRow &&
        id == other.id &&
        evidenceType == other.evidenceType &&
        origin == other.origin &&
        validFrom == other.validFrom &&
        validUntil == other.validUntil &&
        reviewState == other.reviewState &&
        reviewedAt == other.reviewedAt &&
        taxProfileVersion == other.taxProfileVersion &&
        taxableYear == other.taxableYear &&
        vendor == other.vendor &&
        decisionHref == other.decisionHref &&
        createdAt == other.createdAt &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, evidenceType.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, validFrom.hashCode);
    _$hash = $jc(_$hash, validUntil.hashCode);
    _$hash = $jc(_$hash, reviewState.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, taxProfileVersion.hashCode);
    _$hash = $jc(_$hash, taxableYear.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, decisionHref.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxEvidenceRow')
          ..add('id', id)
          ..add('evidenceType', evidenceType)
          ..add('origin', origin)
          ..add('validFrom', validFrom)
          ..add('validUntil', validUntil)
          ..add('reviewState', reviewState)
          ..add('reviewedAt', reviewedAt)
          ..add('taxProfileVersion', taxProfileVersion)
          ..add('taxableYear', taxableYear)
          ..add('vendor', vendor)
          ..add('decisionHref', decisionHref)
          ..add('createdAt', createdAt)
          ..add('note', note))
        .toString();
  }
}

class TaxEvidenceRowBuilder
    implements Builder<TaxEvidenceRow, TaxEvidenceRowBuilder> {
  _$TaxEvidenceRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _evidenceType;
  String? get evidenceType => _$this._evidenceType;
  set evidenceType(String? evidenceType) => _$this._evidenceType = evidenceType;

  String? _origin;
  String? get origin => _$this._origin;
  set origin(String? origin) => _$this._origin = origin;

  Date? _validFrom;
  Date? get validFrom => _$this._validFrom;
  set validFrom(Date? validFrom) => _$this._validFrom = validFrom;

  Date? _validUntil;
  Date? get validUntil => _$this._validUntil;
  set validUntil(Date? validUntil) => _$this._validUntil = validUntil;

  String? _reviewState;
  String? get reviewState => _$this._reviewState;
  set reviewState(String? reviewState) => _$this._reviewState = reviewState;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  int? _taxProfileVersion;
  int? get taxProfileVersion => _$this._taxProfileVersion;
  set taxProfileVersion(int? taxProfileVersion) =>
      _$this._taxProfileVersion = taxProfileVersion;

  int? _taxableYear;
  int? get taxableYear => _$this._taxableYear;
  set taxableYear(int? taxableYear) => _$this._taxableYear = taxableYear;

  GeoDemandColumnsInnerBuilder? _vendor;
  GeoDemandColumnsInnerBuilder get vendor =>
      _$this._vendor ??= GeoDemandColumnsInnerBuilder();
  set vendor(GeoDemandColumnsInnerBuilder? vendor) => _$this._vendor = vendor;

  String? _decisionHref;
  String? get decisionHref => _$this._decisionHref;
  set decisionHref(String? decisionHref) => _$this._decisionHref = decisionHref;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TaxEvidenceRowBuilder() {
    TaxEvidenceRow._defaults(this);
  }

  TaxEvidenceRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _evidenceType = $v.evidenceType;
      _origin = $v.origin;
      _validFrom = $v.validFrom;
      _validUntil = $v.validUntil;
      _reviewState = $v.reviewState;
      _reviewedAt = $v.reviewedAt;
      _taxProfileVersion = $v.taxProfileVersion;
      _taxableYear = $v.taxableYear;
      _vendor = $v.vendor.toBuilder();
      _decisionHref = $v.decisionHref;
      _createdAt = $v.createdAt;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxEvidenceRow other) {
    _$v = other as _$TaxEvidenceRow;
  }

  @override
  void update(void Function(TaxEvidenceRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxEvidenceRow build() => _build();

  _$TaxEvidenceRow _build() {
    _$TaxEvidenceRow _$result;
    try {
      _$result = _$v ??
          _$TaxEvidenceRow._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'TaxEvidenceRow', 'id'),
            evidenceType: BuiltValueNullFieldError.checkNotNull(
                evidenceType, r'TaxEvidenceRow', 'evidenceType'),
            origin: BuiltValueNullFieldError.checkNotNull(
                origin, r'TaxEvidenceRow', 'origin'),
            validFrom: validFrom,
            validUntil: validUntil,
            reviewState: BuiltValueNullFieldError.checkNotNull(
                reviewState, r'TaxEvidenceRow', 'reviewState'),
            reviewedAt: reviewedAt,
            taxProfileVersion: BuiltValueNullFieldError.checkNotNull(
                taxProfileVersion, r'TaxEvidenceRow', 'taxProfileVersion'),
            taxableYear: taxableYear,
            vendor: vendor.build(),
            decisionHref: BuiltValueNullFieldError.checkNotNull(
                decisionHref, r'TaxEvidenceRow', 'decisionHref'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'TaxEvidenceRow', 'createdAt'),
            note: BuiltValueNullFieldError.checkNotNull(
                note, r'TaxEvidenceRow', 'note'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        vendor.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TaxEvidenceRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
