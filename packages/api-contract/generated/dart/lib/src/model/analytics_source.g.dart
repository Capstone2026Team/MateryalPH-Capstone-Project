// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_source.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsSource extends AnalyticsSource {
  @override
  final String observationId;
  @override
  final String storeName;
  @override
  final String listingId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final int priceVersion;
  @override
  final int ordinaryPayableCentavos;
  @override
  final String normalizedPhpExact;
  @override
  final String taxCategory;
  @override
  final DateTime capturedAt;
  @override
  final DateTime? priceEffectiveAt;
  @override
  final bool selectedForAverage;
  @override
  final String? exclusionReason;
  @override
  final BuiltMap<String, JsonObject?> geography;

  factory _$AnalyticsSource([void Function(AnalyticsSourceBuilder)? updates]) =>
      (AnalyticsSourceBuilder()..update(updates))._build();

  _$AnalyticsSource._(
      {required this.observationId,
      required this.storeName,
      required this.listingId,
      required this.displayName,
      this.variantLabel,
      required this.priceVersion,
      required this.ordinaryPayableCentavos,
      required this.normalizedPhpExact,
      required this.taxCategory,
      required this.capturedAt,
      this.priceEffectiveAt,
      required this.selectedForAverage,
      this.exclusionReason,
      required this.geography})
      : super._();
  @override
  AnalyticsSource rebuild(void Function(AnalyticsSourceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsSourceBuilder toBuilder() => AnalyticsSourceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsSource &&
        observationId == other.observationId &&
        storeName == other.storeName &&
        listingId == other.listingId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        priceVersion == other.priceVersion &&
        ordinaryPayableCentavos == other.ordinaryPayableCentavos &&
        normalizedPhpExact == other.normalizedPhpExact &&
        taxCategory == other.taxCategory &&
        capturedAt == other.capturedAt &&
        priceEffectiveAt == other.priceEffectiveAt &&
        selectedForAverage == other.selectedForAverage &&
        exclusionReason == other.exclusionReason &&
        geography == other.geography;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, observationId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, priceVersion.hashCode);
    _$hash = $jc(_$hash, ordinaryPayableCentavos.hashCode);
    _$hash = $jc(_$hash, normalizedPhpExact.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, capturedAt.hashCode);
    _$hash = $jc(_$hash, priceEffectiveAt.hashCode);
    _$hash = $jc(_$hash, selectedForAverage.hashCode);
    _$hash = $jc(_$hash, exclusionReason.hashCode);
    _$hash = $jc(_$hash, geography.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsSource')
          ..add('observationId', observationId)
          ..add('storeName', storeName)
          ..add('listingId', listingId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('priceVersion', priceVersion)
          ..add('ordinaryPayableCentavos', ordinaryPayableCentavos)
          ..add('normalizedPhpExact', normalizedPhpExact)
          ..add('taxCategory', taxCategory)
          ..add('capturedAt', capturedAt)
          ..add('priceEffectiveAt', priceEffectiveAt)
          ..add('selectedForAverage', selectedForAverage)
          ..add('exclusionReason', exclusionReason)
          ..add('geography', geography))
        .toString();
  }
}

class AnalyticsSourceBuilder
    implements Builder<AnalyticsSource, AnalyticsSourceBuilder> {
  _$AnalyticsSource? _$v;

  String? _observationId;
  String? get observationId => _$this._observationId;
  set observationId(String? observationId) =>
      _$this._observationId = observationId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  int? _priceVersion;
  int? get priceVersion => _$this._priceVersion;
  set priceVersion(int? priceVersion) => _$this._priceVersion = priceVersion;

  int? _ordinaryPayableCentavos;
  int? get ordinaryPayableCentavos => _$this._ordinaryPayableCentavos;
  set ordinaryPayableCentavos(int? ordinaryPayableCentavos) =>
      _$this._ordinaryPayableCentavos = ordinaryPayableCentavos;

  String? _normalizedPhpExact;
  String? get normalizedPhpExact => _$this._normalizedPhpExact;
  set normalizedPhpExact(String? normalizedPhpExact) =>
      _$this._normalizedPhpExact = normalizedPhpExact;

  String? _taxCategory;
  String? get taxCategory => _$this._taxCategory;
  set taxCategory(String? taxCategory) => _$this._taxCategory = taxCategory;

  DateTime? _capturedAt;
  DateTime? get capturedAt => _$this._capturedAt;
  set capturedAt(DateTime? capturedAt) => _$this._capturedAt = capturedAt;

  DateTime? _priceEffectiveAt;
  DateTime? get priceEffectiveAt => _$this._priceEffectiveAt;
  set priceEffectiveAt(DateTime? priceEffectiveAt) =>
      _$this._priceEffectiveAt = priceEffectiveAt;

  bool? _selectedForAverage;
  bool? get selectedForAverage => _$this._selectedForAverage;
  set selectedForAverage(bool? selectedForAverage) =>
      _$this._selectedForAverage = selectedForAverage;

  String? _exclusionReason;
  String? get exclusionReason => _$this._exclusionReason;
  set exclusionReason(String? exclusionReason) =>
      _$this._exclusionReason = exclusionReason;

  MapBuilder<String, JsonObject?>? _geography;
  MapBuilder<String, JsonObject?> get geography =>
      _$this._geography ??= MapBuilder<String, JsonObject?>();
  set geography(MapBuilder<String, JsonObject?>? geography) =>
      _$this._geography = geography;

  AnalyticsSourceBuilder() {
    AnalyticsSource._defaults(this);
  }

  AnalyticsSourceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _observationId = $v.observationId;
      _storeName = $v.storeName;
      _listingId = $v.listingId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _priceVersion = $v.priceVersion;
      _ordinaryPayableCentavos = $v.ordinaryPayableCentavos;
      _normalizedPhpExact = $v.normalizedPhpExact;
      _taxCategory = $v.taxCategory;
      _capturedAt = $v.capturedAt;
      _priceEffectiveAt = $v.priceEffectiveAt;
      _selectedForAverage = $v.selectedForAverage;
      _exclusionReason = $v.exclusionReason;
      _geography = $v.geography.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsSource other) {
    _$v = other as _$AnalyticsSource;
  }

  @override
  void update(void Function(AnalyticsSourceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsSource build() => _build();

  _$AnalyticsSource _build() {
    _$AnalyticsSource _$result;
    try {
      _$result = _$v ??
          _$AnalyticsSource._(
            observationId: BuiltValueNullFieldError.checkNotNull(
                observationId, r'AnalyticsSource', 'observationId'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'AnalyticsSource', 'storeName'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'AnalyticsSource', 'listingId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'AnalyticsSource', 'displayName'),
            variantLabel: variantLabel,
            priceVersion: BuiltValueNullFieldError.checkNotNull(
                priceVersion, r'AnalyticsSource', 'priceVersion'),
            ordinaryPayableCentavos: BuiltValueNullFieldError.checkNotNull(
                ordinaryPayableCentavos,
                r'AnalyticsSource',
                'ordinaryPayableCentavos'),
            normalizedPhpExact: BuiltValueNullFieldError.checkNotNull(
                normalizedPhpExact, r'AnalyticsSource', 'normalizedPhpExact'),
            taxCategory: BuiltValueNullFieldError.checkNotNull(
                taxCategory, r'AnalyticsSource', 'taxCategory'),
            capturedAt: BuiltValueNullFieldError.checkNotNull(
                capturedAt, r'AnalyticsSource', 'capturedAt'),
            priceEffectiveAt: priceEffectiveAt,
            selectedForAverage: BuiltValueNullFieldError.checkNotNull(
                selectedForAverage, r'AnalyticsSource', 'selectedForAverage'),
            exclusionReason: exclusionReason,
            geography: geography.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'geography';
        geography.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AnalyticsSource', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
