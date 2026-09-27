// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_compliance_case_envelope_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductComplianceCaseEnvelopeData
    extends ProductComplianceCaseEnvelopeData {
  @override
  final BuiltMap<String, JsonObject?> submission;
  @override
  final BuiltMap<String, JsonObject?>? listing;
  @override
  final RegulatedMaterialRule? rule;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> evidence;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> extractions;
  @override
  final BuiltMap<String, JsonObject?>? referenceMatch;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> previousSubmissions;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> reviews;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> officialReferences;

  factory _$ProductComplianceCaseEnvelopeData(
          [void Function(ProductComplianceCaseEnvelopeDataBuilder)? updates]) =>
      (ProductComplianceCaseEnvelopeDataBuilder()..update(updates))._build();

  _$ProductComplianceCaseEnvelopeData._(
      {required this.submission,
      this.listing,
      this.rule,
      required this.evidence,
      required this.extractions,
      this.referenceMatch,
      required this.previousSubmissions,
      required this.reviews,
      required this.officialReferences})
      : super._();
  @override
  ProductComplianceCaseEnvelopeData rebuild(
          void Function(ProductComplianceCaseEnvelopeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductComplianceCaseEnvelopeDataBuilder toBuilder() =>
      ProductComplianceCaseEnvelopeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductComplianceCaseEnvelopeData &&
        submission == other.submission &&
        listing == other.listing &&
        rule == other.rule &&
        evidence == other.evidence &&
        extractions == other.extractions &&
        referenceMatch == other.referenceMatch &&
        previousSubmissions == other.previousSubmissions &&
        reviews == other.reviews &&
        officialReferences == other.officialReferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, submission.hashCode);
    _$hash = $jc(_$hash, listing.hashCode);
    _$hash = $jc(_$hash, rule.hashCode);
    _$hash = $jc(_$hash, evidence.hashCode);
    _$hash = $jc(_$hash, extractions.hashCode);
    _$hash = $jc(_$hash, referenceMatch.hashCode);
    _$hash = $jc(_$hash, previousSubmissions.hashCode);
    _$hash = $jc(_$hash, reviews.hashCode);
    _$hash = $jc(_$hash, officialReferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductComplianceCaseEnvelopeData')
          ..add('submission', submission)
          ..add('listing', listing)
          ..add('rule', rule)
          ..add('evidence', evidence)
          ..add('extractions', extractions)
          ..add('referenceMatch', referenceMatch)
          ..add('previousSubmissions', previousSubmissions)
          ..add('reviews', reviews)
          ..add('officialReferences', officialReferences))
        .toString();
  }
}

class ProductComplianceCaseEnvelopeDataBuilder
    implements
        Builder<ProductComplianceCaseEnvelopeData,
            ProductComplianceCaseEnvelopeDataBuilder> {
  _$ProductComplianceCaseEnvelopeData? _$v;

  MapBuilder<String, JsonObject?>? _submission;
  MapBuilder<String, JsonObject?> get submission =>
      _$this._submission ??= MapBuilder<String, JsonObject?>();
  set submission(MapBuilder<String, JsonObject?>? submission) =>
      _$this._submission = submission;

  MapBuilder<String, JsonObject?>? _listing;
  MapBuilder<String, JsonObject?> get listing =>
      _$this._listing ??= MapBuilder<String, JsonObject?>();
  set listing(MapBuilder<String, JsonObject?>? listing) =>
      _$this._listing = listing;

  RegulatedMaterialRuleBuilder? _rule;
  RegulatedMaterialRuleBuilder get rule =>
      _$this._rule ??= RegulatedMaterialRuleBuilder();
  set rule(RegulatedMaterialRuleBuilder? rule) => _$this._rule = rule;

  ListBuilder<BuiltMap<String, JsonObject?>>? _evidence;
  ListBuilder<BuiltMap<String, JsonObject?>> get evidence =>
      _$this._evidence ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set evidence(ListBuilder<BuiltMap<String, JsonObject?>>? evidence) =>
      _$this._evidence = evidence;

  ListBuilder<BuiltMap<String, JsonObject?>>? _extractions;
  ListBuilder<BuiltMap<String, JsonObject?>> get extractions =>
      _$this._extractions ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set extractions(ListBuilder<BuiltMap<String, JsonObject?>>? extractions) =>
      _$this._extractions = extractions;

  MapBuilder<String, JsonObject?>? _referenceMatch;
  MapBuilder<String, JsonObject?> get referenceMatch =>
      _$this._referenceMatch ??= MapBuilder<String, JsonObject?>();
  set referenceMatch(MapBuilder<String, JsonObject?>? referenceMatch) =>
      _$this._referenceMatch = referenceMatch;

  ListBuilder<BuiltMap<String, JsonObject?>>? _previousSubmissions;
  ListBuilder<BuiltMap<String, JsonObject?>> get previousSubmissions =>
      _$this._previousSubmissions ??=
          ListBuilder<BuiltMap<String, JsonObject?>>();
  set previousSubmissions(
          ListBuilder<BuiltMap<String, JsonObject?>>? previousSubmissions) =>
      _$this._previousSubmissions = previousSubmissions;

  ListBuilder<BuiltMap<String, JsonObject?>>? _reviews;
  ListBuilder<BuiltMap<String, JsonObject?>> get reviews =>
      _$this._reviews ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set reviews(ListBuilder<BuiltMap<String, JsonObject?>>? reviews) =>
      _$this._reviews = reviews;

  ListBuilder<BuiltMap<String, JsonObject?>>? _officialReferences;
  ListBuilder<BuiltMap<String, JsonObject?>> get officialReferences =>
      _$this._officialReferences ??=
          ListBuilder<BuiltMap<String, JsonObject?>>();
  set officialReferences(
          ListBuilder<BuiltMap<String, JsonObject?>>? officialReferences) =>
      _$this._officialReferences = officialReferences;

  ProductComplianceCaseEnvelopeDataBuilder() {
    ProductComplianceCaseEnvelopeData._defaults(this);
  }

  ProductComplianceCaseEnvelopeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _submission = $v.submission.toBuilder();
      _listing = $v.listing?.toBuilder();
      _rule = $v.rule?.toBuilder();
      _evidence = $v.evidence.toBuilder();
      _extractions = $v.extractions.toBuilder();
      _referenceMatch = $v.referenceMatch?.toBuilder();
      _previousSubmissions = $v.previousSubmissions.toBuilder();
      _reviews = $v.reviews.toBuilder();
      _officialReferences = $v.officialReferences.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductComplianceCaseEnvelopeData other) {
    _$v = other as _$ProductComplianceCaseEnvelopeData;
  }

  @override
  void update(
      void Function(ProductComplianceCaseEnvelopeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductComplianceCaseEnvelopeData build() => _build();

  _$ProductComplianceCaseEnvelopeData _build() {
    _$ProductComplianceCaseEnvelopeData _$result;
    try {
      _$result = _$v ??
          _$ProductComplianceCaseEnvelopeData._(
            submission: submission.build(),
            listing: _listing?.build(),
            rule: _rule?.build(),
            evidence: evidence.build(),
            extractions: extractions.build(),
            referenceMatch: _referenceMatch?.build(),
            previousSubmissions: previousSubmissions.build(),
            reviews: reviews.build(),
            officialReferences: officialReferences.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'submission';
        submission.build();
        _$failedField = 'listing';
        _listing?.build();
        _$failedField = 'rule';
        _rule?.build();
        _$failedField = 'evidence';
        evidence.build();
        _$failedField = 'extractions';
        extractions.build();
        _$failedField = 'referenceMatch';
        _referenceMatch?.build();
        _$failedField = 'previousSubmissions';
        previousSubmissions.build();
        _$failedField = 'reviews';
        reviews.build();
        _$failedField = 'officialReferences';
        officialReferences.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProductComplianceCaseEnvelopeData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
