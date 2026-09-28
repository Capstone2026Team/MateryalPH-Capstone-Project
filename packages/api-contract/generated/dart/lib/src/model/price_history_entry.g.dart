// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PriceHistoryEntryPriceKindEnum _$priceHistoryEntryPriceKindEnum_ORDINARY =
    const PriceHistoryEntryPriceKindEnum._('ORDINARY');
const PriceHistoryEntryPriceKindEnum
    _$priceHistoryEntryPriceKindEnum_PROMOTIONAL =
    const PriceHistoryEntryPriceKindEnum._('PROMOTIONAL');
const PriceHistoryEntryPriceKindEnum
    _$priceHistoryEntryPriceKindEnum_VOLUME_TIER =
    const PriceHistoryEntryPriceKindEnum._('VOLUME_TIER');
const PriceHistoryEntryPriceKindEnum
    _$priceHistoryEntryPriceKindEnum_NEGOTIATED =
    const PriceHistoryEntryPriceKindEnum._('NEGOTIATED');

PriceHistoryEntryPriceKindEnum _$priceHistoryEntryPriceKindEnumValueOf(
    String name) {
  switch (name) {
    case 'ORDINARY':
      return _$priceHistoryEntryPriceKindEnum_ORDINARY;
    case 'PROMOTIONAL':
      return _$priceHistoryEntryPriceKindEnum_PROMOTIONAL;
    case 'VOLUME_TIER':
      return _$priceHistoryEntryPriceKindEnum_VOLUME_TIER;
    case 'NEGOTIATED':
      return _$priceHistoryEntryPriceKindEnum_NEGOTIATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PriceHistoryEntryPriceKindEnum>
    _$priceHistoryEntryPriceKindEnumValues = BuiltSet<
        PriceHistoryEntryPriceKindEnum>(const <PriceHistoryEntryPriceKindEnum>[
  _$priceHistoryEntryPriceKindEnum_ORDINARY,
  _$priceHistoryEntryPriceKindEnum_PROMOTIONAL,
  _$priceHistoryEntryPriceKindEnum_VOLUME_TIER,
  _$priceHistoryEntryPriceKindEnum_NEGOTIATED,
]);

Serializer<PriceHistoryEntryPriceKindEnum>
    _$priceHistoryEntryPriceKindEnumSerializer =
    _$PriceHistoryEntryPriceKindEnumSerializer();

class _$PriceHistoryEntryPriceKindEnumSerializer
    implements PrimitiveSerializer<PriceHistoryEntryPriceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDINARY': 'ORDINARY',
    'PROMOTIONAL': 'PROMOTIONAL',
    'VOLUME_TIER': 'VOLUME_TIER',
    'NEGOTIATED': 'NEGOTIATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDINARY': 'ORDINARY',
    'PROMOTIONAL': 'PROMOTIONAL',
    'VOLUME_TIER': 'VOLUME_TIER',
    'NEGOTIATED': 'NEGOTIATED',
  };

  @override
  final Iterable<Type> types = const <Type>[PriceHistoryEntryPriceKindEnum];
  @override
  final String wireName = 'PriceHistoryEntryPriceKindEnum';

  @override
  Object serialize(
          Serializers serializers, PriceHistoryEntryPriceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PriceHistoryEntryPriceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PriceHistoryEntryPriceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PriceHistoryEntry extends PriceHistoryEntry {
  @override
  final String priceVersionId;
  @override
  final int version;
  @override
  final PriceHistoryEntryPriceKindEnum priceKind;
  @override
  final int amountCentavos;
  @override
  final TaxCategory taxCategory;
  @override
  final String? minimumQuantity;
  @override
  final int includedVatCentavos;
  @override
  final String? effectiveAt;
  @override
  final String? retiredAt;
  @override
  final String? supersedesPriceVersionId;
  @override
  final bool current;
  @override
  final String? createdBy;

  factory _$PriceHistoryEntry(
          [void Function(PriceHistoryEntryBuilder)? updates]) =>
      (PriceHistoryEntryBuilder()..update(updates))._build();

  _$PriceHistoryEntry._(
      {required this.priceVersionId,
      required this.version,
      required this.priceKind,
      required this.amountCentavos,
      required this.taxCategory,
      this.minimumQuantity,
      required this.includedVatCentavos,
      this.effectiveAt,
      this.retiredAt,
      this.supersedesPriceVersionId,
      required this.current,
      this.createdBy})
      : super._();
  @override
  PriceHistoryEntry rebuild(void Function(PriceHistoryEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PriceHistoryEntryBuilder toBuilder() =>
      PriceHistoryEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PriceHistoryEntry &&
        priceVersionId == other.priceVersionId &&
        version == other.version &&
        priceKind == other.priceKind &&
        amountCentavos == other.amountCentavos &&
        taxCategory == other.taxCategory &&
        minimumQuantity == other.minimumQuantity &&
        includedVatCentavos == other.includedVatCentavos &&
        effectiveAt == other.effectiveAt &&
        retiredAt == other.retiredAt &&
        supersedesPriceVersionId == other.supersedesPriceVersionId &&
        current == other.current &&
        createdBy == other.createdBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, priceKind.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, minimumQuantity.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jc(_$hash, retiredAt.hashCode);
    _$hash = $jc(_$hash, supersedesPriceVersionId.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PriceHistoryEntry')
          ..add('priceVersionId', priceVersionId)
          ..add('version', version)
          ..add('priceKind', priceKind)
          ..add('amountCentavos', amountCentavos)
          ..add('taxCategory', taxCategory)
          ..add('minimumQuantity', minimumQuantity)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('effectiveAt', effectiveAt)
          ..add('retiredAt', retiredAt)
          ..add('supersedesPriceVersionId', supersedesPriceVersionId)
          ..add('current', current)
          ..add('createdBy', createdBy))
        .toString();
  }
}

class PriceHistoryEntryBuilder
    implements Builder<PriceHistoryEntry, PriceHistoryEntryBuilder> {
  _$PriceHistoryEntry? _$v;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  PriceHistoryEntryPriceKindEnum? _priceKind;
  PriceHistoryEntryPriceKindEnum? get priceKind => _$this._priceKind;
  set priceKind(PriceHistoryEntryPriceKindEnum? priceKind) =>
      _$this._priceKind = priceKind;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  TaxCategory? _taxCategory;
  TaxCategory? get taxCategory => _$this._taxCategory;
  set taxCategory(TaxCategory? taxCategory) =>
      _$this._taxCategory = taxCategory;

  String? _minimumQuantity;
  String? get minimumQuantity => _$this._minimumQuantity;
  set minimumQuantity(String? minimumQuantity) =>
      _$this._minimumQuantity = minimumQuantity;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  String? _effectiveAt;
  String? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(String? effectiveAt) => _$this._effectiveAt = effectiveAt;

  String? _retiredAt;
  String? get retiredAt => _$this._retiredAt;
  set retiredAt(String? retiredAt) => _$this._retiredAt = retiredAt;

  String? _supersedesPriceVersionId;
  String? get supersedesPriceVersionId => _$this._supersedesPriceVersionId;
  set supersedesPriceVersionId(String? supersedesPriceVersionId) =>
      _$this._supersedesPriceVersionId = supersedesPriceVersionId;

  bool? _current;
  bool? get current => _$this._current;
  set current(bool? current) => _$this._current = current;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  PriceHistoryEntryBuilder() {
    PriceHistoryEntry._defaults(this);
  }

  PriceHistoryEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _version = $v.version;
      _priceKind = $v.priceKind;
      _amountCentavos = $v.amountCentavos;
      _taxCategory = $v.taxCategory;
      _minimumQuantity = $v.minimumQuantity;
      _includedVatCentavos = $v.includedVatCentavos;
      _effectiveAt = $v.effectiveAt;
      _retiredAt = $v.retiredAt;
      _supersedesPriceVersionId = $v.supersedesPriceVersionId;
      _current = $v.current;
      _createdBy = $v.createdBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PriceHistoryEntry other) {
    _$v = other as _$PriceHistoryEntry;
  }

  @override
  void update(void Function(PriceHistoryEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PriceHistoryEntry build() => _build();

  _$PriceHistoryEntry _build() {
    final _$result = _$v ??
        _$PriceHistoryEntry._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'PriceHistoryEntry', 'priceVersionId'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'PriceHistoryEntry', 'version'),
          priceKind: BuiltValueNullFieldError.checkNotNull(
              priceKind, r'PriceHistoryEntry', 'priceKind'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'PriceHistoryEntry', 'amountCentavos'),
          taxCategory: BuiltValueNullFieldError.checkNotNull(
              taxCategory, r'PriceHistoryEntry', 'taxCategory'),
          minimumQuantity: minimumQuantity,
          includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
              includedVatCentavos, r'PriceHistoryEntry', 'includedVatCentavos'),
          effectiveAt: effectiveAt,
          retiredAt: retiredAt,
          supersedesPriceVersionId: supersedesPriceVersionId,
          current: BuiltValueNullFieldError.checkNotNull(
              current, r'PriceHistoryEntry', 'current'),
          createdBy: createdBy,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
