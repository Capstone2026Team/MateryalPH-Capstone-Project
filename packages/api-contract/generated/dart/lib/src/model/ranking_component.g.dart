// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_component.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RankingComponentKeyEnum _$rankingComponentKeyEnum_distance =
    const RankingComponentKeyEnum._('distance');
const RankingComponentKeyEnum _$rankingComponentKeyEnum_price =
    const RankingComponentKeyEnum._('price');
const RankingComponentKeyEnum _$rankingComponentKeyEnum_vps =
    const RankingComponentKeyEnum._('vps');
const RankingComponentKeyEnum _$rankingComponentKeyEnum_stock =
    const RankingComponentKeyEnum._('stock');
const RankingComponentKeyEnum _$rankingComponentKeyEnum_productRating =
    const RankingComponentKeyEnum._('productRating');

RankingComponentKeyEnum _$rankingComponentKeyEnumValueOf(String name) {
  switch (name) {
    case 'distance':
      return _$rankingComponentKeyEnum_distance;
    case 'price':
      return _$rankingComponentKeyEnum_price;
    case 'vps':
      return _$rankingComponentKeyEnum_vps;
    case 'stock':
      return _$rankingComponentKeyEnum_stock;
    case 'productRating':
      return _$rankingComponentKeyEnum_productRating;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RankingComponentKeyEnum> _$rankingComponentKeyEnumValues =
    BuiltSet<RankingComponentKeyEnum>(const <RankingComponentKeyEnum>[
  _$rankingComponentKeyEnum_distance,
  _$rankingComponentKeyEnum_price,
  _$rankingComponentKeyEnum_vps,
  _$rankingComponentKeyEnum_stock,
  _$rankingComponentKeyEnum_productRating,
]);

Serializer<RankingComponentKeyEnum> _$rankingComponentKeyEnumSerializer =
    _$RankingComponentKeyEnumSerializer();

class _$RankingComponentKeyEnumSerializer
    implements PrimitiveSerializer<RankingComponentKeyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'distance': 'distance',
    'price': 'price',
    'vps': 'vps',
    'stock': 'stock',
    'productRating': 'product_rating',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'distance': 'distance',
    'price': 'price',
    'vps': 'vps',
    'stock': 'stock',
    'product_rating': 'productRating',
  };

  @override
  final Iterable<Type> types = const <Type>[RankingComponentKeyEnum];
  @override
  final String wireName = 'RankingComponentKeyEnum';

  @override
  Object serialize(Serializers serializers, RankingComponentKeyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RankingComponentKeyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RankingComponentKeyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RankingComponent extends RankingComponent {
  @override
  final RankingComponentKeyEnum key;
  @override
  final String label;
  @override
  final int weightPercent;
  @override
  final String score;
  @override
  final String weighted;
  @override
  final String basis;

  factory _$RankingComponent(
          [void Function(RankingComponentBuilder)? updates]) =>
      (RankingComponentBuilder()..update(updates))._build();

  _$RankingComponent._(
      {required this.key,
      required this.label,
      required this.weightPercent,
      required this.score,
      required this.weighted,
      required this.basis})
      : super._();
  @override
  RankingComponent rebuild(void Function(RankingComponentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingComponentBuilder toBuilder() =>
      RankingComponentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingComponent &&
        key == other.key &&
        label == other.label &&
        weightPercent == other.weightPercent &&
        score == other.score &&
        weighted == other.weighted &&
        basis == other.basis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, weightPercent.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, weighted.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RankingComponent')
          ..add('key', key)
          ..add('label', label)
          ..add('weightPercent', weightPercent)
          ..add('score', score)
          ..add('weighted', weighted)
          ..add('basis', basis))
        .toString();
  }
}

class RankingComponentBuilder
    implements Builder<RankingComponent, RankingComponentBuilder> {
  _$RankingComponent? _$v;

  RankingComponentKeyEnum? _key;
  RankingComponentKeyEnum? get key => _$this._key;
  set key(RankingComponentKeyEnum? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _weightPercent;
  int? get weightPercent => _$this._weightPercent;
  set weightPercent(int? weightPercent) =>
      _$this._weightPercent = weightPercent;

  String? _score;
  String? get score => _$this._score;
  set score(String? score) => _$this._score = score;

  String? _weighted;
  String? get weighted => _$this._weighted;
  set weighted(String? weighted) => _$this._weighted = weighted;

  String? _basis;
  String? get basis => _$this._basis;
  set basis(String? basis) => _$this._basis = basis;

  RankingComponentBuilder() {
    RankingComponent._defaults(this);
  }

  RankingComponentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _weightPercent = $v.weightPercent;
      _score = $v.score;
      _weighted = $v.weighted;
      _basis = $v.basis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RankingComponent other) {
    _$v = other as _$RankingComponent;
  }

  @override
  void update(void Function(RankingComponentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingComponent build() => _build();

  _$RankingComponent _build() {
    final _$result = _$v ??
        _$RankingComponent._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'RankingComponent', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'RankingComponent', 'label'),
          weightPercent: BuiltValueNullFieldError.checkNotNull(
              weightPercent, r'RankingComponent', 'weightPercent'),
          score: BuiltValueNullFieldError.checkNotNull(
              score, r'RankingComponent', 'score'),
          weighted: BuiltValueNullFieldError.checkNotNull(
              weighted, r'RankingComponent', 'weighted'),
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'RankingComponent', 'basis'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
