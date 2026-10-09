// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_finance_reviews.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFinanceReviews extends VendorFinanceReviews {
  @override
  final String label;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> statements;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> taxAdjustments;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> evidence;
  @override
  final BuiltList<VendorFinanceReviewsOpenReviewsInner> openReviews;

  factory _$VendorFinanceReviews(
          [void Function(VendorFinanceReviewsBuilder)? updates]) =>
      (VendorFinanceReviewsBuilder()..update(updates))._build();

  _$VendorFinanceReviews._(
      {required this.label,
      required this.statements,
      required this.taxAdjustments,
      required this.evidence,
      required this.openReviews})
      : super._();
  @override
  VendorFinanceReviews rebuild(
          void Function(VendorFinanceReviewsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFinanceReviewsBuilder toBuilder() =>
      VendorFinanceReviewsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFinanceReviews &&
        label == other.label &&
        statements == other.statements &&
        taxAdjustments == other.taxAdjustments &&
        evidence == other.evidence &&
        openReviews == other.openReviews;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, statements.hashCode);
    _$hash = $jc(_$hash, taxAdjustments.hashCode);
    _$hash = $jc(_$hash, evidence.hashCode);
    _$hash = $jc(_$hash, openReviews.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorFinanceReviews')
          ..add('label', label)
          ..add('statements', statements)
          ..add('taxAdjustments', taxAdjustments)
          ..add('evidence', evidence)
          ..add('openReviews', openReviews))
        .toString();
  }
}

class VendorFinanceReviewsBuilder
    implements Builder<VendorFinanceReviews, VendorFinanceReviewsBuilder> {
  _$VendorFinanceReviews? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<BuiltMap<String, JsonObject?>>? _statements;
  ListBuilder<BuiltMap<String, JsonObject?>> get statements =>
      _$this._statements ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set statements(ListBuilder<BuiltMap<String, JsonObject?>>? statements) =>
      _$this._statements = statements;

  ListBuilder<BuiltMap<String, JsonObject?>>? _taxAdjustments;
  ListBuilder<BuiltMap<String, JsonObject?>> get taxAdjustments =>
      _$this._taxAdjustments ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set taxAdjustments(
          ListBuilder<BuiltMap<String, JsonObject?>>? taxAdjustments) =>
      _$this._taxAdjustments = taxAdjustments;

  ListBuilder<BuiltMap<String, JsonObject?>>? _evidence;
  ListBuilder<BuiltMap<String, JsonObject?>> get evidence =>
      _$this._evidence ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set evidence(ListBuilder<BuiltMap<String, JsonObject?>>? evidence) =>
      _$this._evidence = evidence;

  ListBuilder<VendorFinanceReviewsOpenReviewsInner>? _openReviews;
  ListBuilder<VendorFinanceReviewsOpenReviewsInner> get openReviews =>
      _$this._openReviews ??=
          ListBuilder<VendorFinanceReviewsOpenReviewsInner>();
  set openReviews(
          ListBuilder<VendorFinanceReviewsOpenReviewsInner>? openReviews) =>
      _$this._openReviews = openReviews;

  VendorFinanceReviewsBuilder() {
    VendorFinanceReviews._defaults(this);
  }

  VendorFinanceReviewsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _statements = $v.statements.toBuilder();
      _taxAdjustments = $v.taxAdjustments.toBuilder();
      _evidence = $v.evidence.toBuilder();
      _openReviews = $v.openReviews.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorFinanceReviews other) {
    _$v = other as _$VendorFinanceReviews;
  }

  @override
  void update(void Function(VendorFinanceReviewsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFinanceReviews build() => _build();

  _$VendorFinanceReviews _build() {
    _$VendorFinanceReviews _$result;
    try {
      _$result = _$v ??
          _$VendorFinanceReviews._(
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'VendorFinanceReviews', 'label'),
            statements: statements.build(),
            taxAdjustments: taxAdjustments.build(),
            evidence: evidence.build(),
            openReviews: openReviews.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statements';
        statements.build();
        _$failedField = 'taxAdjustments';
        taxAdjustments.build();
        _$failedField = 'evidence';
        evidence.build();
        _$failedField = 'openReviews';
        openReviews.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorFinanceReviews', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
