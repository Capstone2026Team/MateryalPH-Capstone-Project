// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_child.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeoChildSuppressionReasonEnum _$geoChildSuppressionReasonEnum_SMALL_CELL =
    const GeoChildSuppressionReasonEnum._('SMALL_CELL');
const GeoChildSuppressionReasonEnum
    _$geoChildSuppressionReasonEnum_COMPLEMENTARY =
    const GeoChildSuppressionReasonEnum._('COMPLEMENTARY');

GeoChildSuppressionReasonEnum _$geoChildSuppressionReasonEnumValueOf(
    String name) {
  switch (name) {
    case 'SMALL_CELL':
      return _$geoChildSuppressionReasonEnum_SMALL_CELL;
    case 'COMPLEMENTARY':
      return _$geoChildSuppressionReasonEnum_COMPLEMENTARY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GeoChildSuppressionReasonEnum>
    _$geoChildSuppressionReasonEnumValues = BuiltSet<
        GeoChildSuppressionReasonEnum>(const <GeoChildSuppressionReasonEnum>[
  _$geoChildSuppressionReasonEnum_SMALL_CELL,
  _$geoChildSuppressionReasonEnum_COMPLEMENTARY,
]);

Serializer<GeoChildSuppressionReasonEnum>
    _$geoChildSuppressionReasonEnumSerializer =
    _$GeoChildSuppressionReasonEnumSerializer();

class _$GeoChildSuppressionReasonEnumSerializer
    implements PrimitiveSerializer<GeoChildSuppressionReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SMALL_CELL': 'SMALL_CELL',
    'COMPLEMENTARY': 'COMPLEMENTARY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SMALL_CELL': 'SMALL_CELL',
    'COMPLEMENTARY': 'COMPLEMENTARY',
  };

  @override
  final Iterable<Type> types = const <Type>[GeoChildSuppressionReasonEnum];
  @override
  final String wireName = 'GeoChildSuppressionReasonEnum';

  @override
  Object serialize(
          Serializers serializers, GeoChildSuppressionReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeoChildSuppressionReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeoChildSuppressionReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeoChild extends GeoChild {
  @override
  final String code;
  @override
  final String name;
  @override
  final String level;
  @override
  final String levelLabel;
  @override
  final bool drillable;
  @override
  final int vendorCount;
  @override
  final GeoChildRegisteredBuyers registeredBuyers;
  @override
  final GeoChildRegisteredBuyers grossGmvCentavos;
  @override
  final GeoChildRegisteredBuyers netGmvCentavos;
  @override
  final GeoChildRegisteredBuyers orderVolume;
  @override
  final GeoRate fulfillmentRate;
  @override
  final GeoRate cancellationRate;
  @override
  final GeoRate disputeRate;
  @override
  final int? medianResponseSeconds;
  @override
  final bool responseSuppressed;
  @override
  final bool suppressed;
  @override
  final GeoChildSuppressionReasonEnum? suppressionReason;
  @override
  final String? suppressionNote;

  factory _$GeoChild([void Function(GeoChildBuilder)? updates]) =>
      (GeoChildBuilder()..update(updates))._build();

  _$GeoChild._(
      {required this.code,
      required this.name,
      required this.level,
      required this.levelLabel,
      required this.drillable,
      required this.vendorCount,
      required this.registeredBuyers,
      required this.grossGmvCentavos,
      required this.netGmvCentavos,
      required this.orderVolume,
      required this.fulfillmentRate,
      required this.cancellationRate,
      required this.disputeRate,
      this.medianResponseSeconds,
      required this.responseSuppressed,
      required this.suppressed,
      this.suppressionReason,
      this.suppressionNote})
      : super._();
  @override
  GeoChild rebuild(void Function(GeoChildBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoChildBuilder toBuilder() => GeoChildBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoChild &&
        code == other.code &&
        name == other.name &&
        level == other.level &&
        levelLabel == other.levelLabel &&
        drillable == other.drillable &&
        vendorCount == other.vendorCount &&
        registeredBuyers == other.registeredBuyers &&
        grossGmvCentavos == other.grossGmvCentavos &&
        netGmvCentavos == other.netGmvCentavos &&
        orderVolume == other.orderVolume &&
        fulfillmentRate == other.fulfillmentRate &&
        cancellationRate == other.cancellationRate &&
        disputeRate == other.disputeRate &&
        medianResponseSeconds == other.medianResponseSeconds &&
        responseSuppressed == other.responseSuppressed &&
        suppressed == other.suppressed &&
        suppressionReason == other.suppressionReason &&
        suppressionNote == other.suppressionNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jc(_$hash, levelLabel.hashCode);
    _$hash = $jc(_$hash, drillable.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, registeredBuyers.hashCode);
    _$hash = $jc(_$hash, grossGmvCentavos.hashCode);
    _$hash = $jc(_$hash, netGmvCentavos.hashCode);
    _$hash = $jc(_$hash, orderVolume.hashCode);
    _$hash = $jc(_$hash, fulfillmentRate.hashCode);
    _$hash = $jc(_$hash, cancellationRate.hashCode);
    _$hash = $jc(_$hash, disputeRate.hashCode);
    _$hash = $jc(_$hash, medianResponseSeconds.hashCode);
    _$hash = $jc(_$hash, responseSuppressed.hashCode);
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jc(_$hash, suppressionReason.hashCode);
    _$hash = $jc(_$hash, suppressionNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoChild')
          ..add('code', code)
          ..add('name', name)
          ..add('level', level)
          ..add('levelLabel', levelLabel)
          ..add('drillable', drillable)
          ..add('vendorCount', vendorCount)
          ..add('registeredBuyers', registeredBuyers)
          ..add('grossGmvCentavos', grossGmvCentavos)
          ..add('netGmvCentavos', netGmvCentavos)
          ..add('orderVolume', orderVolume)
          ..add('fulfillmentRate', fulfillmentRate)
          ..add('cancellationRate', cancellationRate)
          ..add('disputeRate', disputeRate)
          ..add('medianResponseSeconds', medianResponseSeconds)
          ..add('responseSuppressed', responseSuppressed)
          ..add('suppressed', suppressed)
          ..add('suppressionReason', suppressionReason)
          ..add('suppressionNote', suppressionNote))
        .toString();
  }
}

class GeoChildBuilder implements Builder<GeoChild, GeoChildBuilder> {
  _$GeoChild? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _level;
  String? get level => _$this._level;
  set level(String? level) => _$this._level = level;

  String? _levelLabel;
  String? get levelLabel => _$this._levelLabel;
  set levelLabel(String? levelLabel) => _$this._levelLabel = levelLabel;

  bool? _drillable;
  bool? get drillable => _$this._drillable;
  set drillable(bool? drillable) => _$this._drillable = drillable;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  GeoChildRegisteredBuyersBuilder? _registeredBuyers;
  GeoChildRegisteredBuyersBuilder get registeredBuyers =>
      _$this._registeredBuyers ??= GeoChildRegisteredBuyersBuilder();
  set registeredBuyers(GeoChildRegisteredBuyersBuilder? registeredBuyers) =>
      _$this._registeredBuyers = registeredBuyers;

  GeoChildRegisteredBuyersBuilder? _grossGmvCentavos;
  GeoChildRegisteredBuyersBuilder get grossGmvCentavos =>
      _$this._grossGmvCentavos ??= GeoChildRegisteredBuyersBuilder();
  set grossGmvCentavos(GeoChildRegisteredBuyersBuilder? grossGmvCentavos) =>
      _$this._grossGmvCentavos = grossGmvCentavos;

  GeoChildRegisteredBuyersBuilder? _netGmvCentavos;
  GeoChildRegisteredBuyersBuilder get netGmvCentavos =>
      _$this._netGmvCentavos ??= GeoChildRegisteredBuyersBuilder();
  set netGmvCentavos(GeoChildRegisteredBuyersBuilder? netGmvCentavos) =>
      _$this._netGmvCentavos = netGmvCentavos;

  GeoChildRegisteredBuyersBuilder? _orderVolume;
  GeoChildRegisteredBuyersBuilder get orderVolume =>
      _$this._orderVolume ??= GeoChildRegisteredBuyersBuilder();
  set orderVolume(GeoChildRegisteredBuyersBuilder? orderVolume) =>
      _$this._orderVolume = orderVolume;

  GeoRateBuilder? _fulfillmentRate;
  GeoRateBuilder get fulfillmentRate =>
      _$this._fulfillmentRate ??= GeoRateBuilder();
  set fulfillmentRate(GeoRateBuilder? fulfillmentRate) =>
      _$this._fulfillmentRate = fulfillmentRate;

  GeoRateBuilder? _cancellationRate;
  GeoRateBuilder get cancellationRate =>
      _$this._cancellationRate ??= GeoRateBuilder();
  set cancellationRate(GeoRateBuilder? cancellationRate) =>
      _$this._cancellationRate = cancellationRate;

  GeoRateBuilder? _disputeRate;
  GeoRateBuilder get disputeRate => _$this._disputeRate ??= GeoRateBuilder();
  set disputeRate(GeoRateBuilder? disputeRate) =>
      _$this._disputeRate = disputeRate;

  int? _medianResponseSeconds;
  int? get medianResponseSeconds => _$this._medianResponseSeconds;
  set medianResponseSeconds(int? medianResponseSeconds) =>
      _$this._medianResponseSeconds = medianResponseSeconds;

  bool? _responseSuppressed;
  bool? get responseSuppressed => _$this._responseSuppressed;
  set responseSuppressed(bool? responseSuppressed) =>
      _$this._responseSuppressed = responseSuppressed;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  GeoChildSuppressionReasonEnum? _suppressionReason;
  GeoChildSuppressionReasonEnum? get suppressionReason =>
      _$this._suppressionReason;
  set suppressionReason(GeoChildSuppressionReasonEnum? suppressionReason) =>
      _$this._suppressionReason = suppressionReason;

  String? _suppressionNote;
  String? get suppressionNote => _$this._suppressionNote;
  set suppressionNote(String? suppressionNote) =>
      _$this._suppressionNote = suppressionNote;

  GeoChildBuilder() {
    GeoChild._defaults(this);
  }

  GeoChildBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _level = $v.level;
      _levelLabel = $v.levelLabel;
      _drillable = $v.drillable;
      _vendorCount = $v.vendorCount;
      _registeredBuyers = $v.registeredBuyers.toBuilder();
      _grossGmvCentavos = $v.grossGmvCentavos.toBuilder();
      _netGmvCentavos = $v.netGmvCentavos.toBuilder();
      _orderVolume = $v.orderVolume.toBuilder();
      _fulfillmentRate = $v.fulfillmentRate.toBuilder();
      _cancellationRate = $v.cancellationRate.toBuilder();
      _disputeRate = $v.disputeRate.toBuilder();
      _medianResponseSeconds = $v.medianResponseSeconds;
      _responseSuppressed = $v.responseSuppressed;
      _suppressed = $v.suppressed;
      _suppressionReason = $v.suppressionReason;
      _suppressionNote = $v.suppressionNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoChild other) {
    _$v = other as _$GeoChild;
  }

  @override
  void update(void Function(GeoChildBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoChild build() => _build();

  _$GeoChild _build() {
    _$GeoChild _$result;
    try {
      _$result = _$v ??
          _$GeoChild._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'GeoChild', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GeoChild', 'name'),
            level: BuiltValueNullFieldError.checkNotNull(
                level, r'GeoChild', 'level'),
            levelLabel: BuiltValueNullFieldError.checkNotNull(
                levelLabel, r'GeoChild', 'levelLabel'),
            drillable: BuiltValueNullFieldError.checkNotNull(
                drillable, r'GeoChild', 'drillable'),
            vendorCount: BuiltValueNullFieldError.checkNotNull(
                vendorCount, r'GeoChild', 'vendorCount'),
            registeredBuyers: registeredBuyers.build(),
            grossGmvCentavos: grossGmvCentavos.build(),
            netGmvCentavos: netGmvCentavos.build(),
            orderVolume: orderVolume.build(),
            fulfillmentRate: fulfillmentRate.build(),
            cancellationRate: cancellationRate.build(),
            disputeRate: disputeRate.build(),
            medianResponseSeconds: medianResponseSeconds,
            responseSuppressed: BuiltValueNullFieldError.checkNotNull(
                responseSuppressed, r'GeoChild', 'responseSuppressed'),
            suppressed: BuiltValueNullFieldError.checkNotNull(
                suppressed, r'GeoChild', 'suppressed'),
            suppressionReason: suppressionReason,
            suppressionNote: suppressionNote,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'registeredBuyers';
        registeredBuyers.build();
        _$failedField = 'grossGmvCentavos';
        grossGmvCentavos.build();
        _$failedField = 'netGmvCentavos';
        netGmvCentavos.build();
        _$failedField = 'orderVolume';
        orderVolume.build();
        _$failedField = 'fulfillmentRate';
        fulfillmentRate.build();
        _$failedField = 'cancellationRate';
        cancellationRate.build();
        _$failedField = 'disputeRate';
        disputeRate.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoChild', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
