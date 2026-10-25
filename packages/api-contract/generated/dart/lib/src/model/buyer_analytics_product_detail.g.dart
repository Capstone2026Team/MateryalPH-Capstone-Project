// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_product_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerAnalyticsProductDetailAudienceEnum
    _$buyerAnalyticsProductDetailAudienceEnum_BUYER =
    const BuyerAnalyticsProductDetailAudienceEnum._('BUYER');

BuyerAnalyticsProductDetailAudienceEnum
    _$buyerAnalyticsProductDetailAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$buyerAnalyticsProductDetailAudienceEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerAnalyticsProductDetailAudienceEnum>
    _$buyerAnalyticsProductDetailAudienceEnumValues = BuiltSet<
        BuyerAnalyticsProductDetailAudienceEnum>(const <BuyerAnalyticsProductDetailAudienceEnum>[
  _$buyerAnalyticsProductDetailAudienceEnum_BUYER,
]);

const BuyerAnalyticsProductDetailSourceKindEnum
    _$buyerAnalyticsProductDetailSourceKindEnum_PUBLIC_LISTING =
    const BuyerAnalyticsProductDetailSourceKindEnum._('PUBLIC_LISTING');

BuyerAnalyticsProductDetailSourceKindEnum
    _$buyerAnalyticsProductDetailSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$buyerAnalyticsProductDetailSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerAnalyticsProductDetailSourceKindEnum>
    _$buyerAnalyticsProductDetailSourceKindEnumValues = BuiltSet<
        BuyerAnalyticsProductDetailSourceKindEnum>(const <BuyerAnalyticsProductDetailSourceKindEnum>[
  _$buyerAnalyticsProductDetailSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<BuyerAnalyticsProductDetailAudienceEnum>
    _$buyerAnalyticsProductDetailAudienceEnumSerializer =
    _$BuyerAnalyticsProductDetailAudienceEnumSerializer();
Serializer<BuyerAnalyticsProductDetailSourceKindEnum>
    _$buyerAnalyticsProductDetailSourceKindEnumSerializer =
    _$BuyerAnalyticsProductDetailSourceKindEnumSerializer();

class _$BuyerAnalyticsProductDetailAudienceEnumSerializer
    implements PrimitiveSerializer<BuyerAnalyticsProductDetailAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerAnalyticsProductDetailAudienceEnum
  ];
  @override
  final String wireName = 'BuyerAnalyticsProductDetailAudienceEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerAnalyticsProductDetailAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerAnalyticsProductDetailAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerAnalyticsProductDetailAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerAnalyticsProductDetailSourceKindEnumSerializer
    implements PrimitiveSerializer<BuyerAnalyticsProductDetailSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerAnalyticsProductDetailSourceKindEnum
  ];
  @override
  final String wireName = 'BuyerAnalyticsProductDetailSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerAnalyticsProductDetailSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerAnalyticsProductDetailSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerAnalyticsProductDetailSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerAnalyticsProductDetail extends BuyerAnalyticsProductDetail {
  @override
  final BuyerAnalyticsProductDetailAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final BuyerAnalyticsProductDetailSourceKindEnum sourceKind;
  @override
  final DatasetLabel dataset;
  @override
  final AnalyticsWindow window;
  @override
  final DateTime currentAsOf;
  @override
  final AnalyticsSnapshotRef? snapshot;
  @override
  final String updateSchedule;
  @override
  final String explanation;
  @override
  final BuyerAnalyticsProductDetailProduct product;
  @override
  final BuyerAnalyticsFeaturedVariant? featured;
  @override
  final BuiltList<BuyerAnalyticsProductVariant> variants;

  factory _$BuyerAnalyticsProductDetail(
          [void Function(BuyerAnalyticsProductDetailBuilder)? updates]) =>
      (BuyerAnalyticsProductDetailBuilder()..update(updates))._build();

  _$BuyerAnalyticsProductDetail._(
      {required this.audience,
      required this.scope,
      required this.sourceKind,
      required this.dataset,
      required this.window,
      required this.currentAsOf,
      this.snapshot,
      required this.updateSchedule,
      required this.explanation,
      required this.product,
      this.featured,
      required this.variants})
      : super._();
  @override
  BuyerAnalyticsProductDetail rebuild(
          void Function(BuyerAnalyticsProductDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAnalyticsProductDetailBuilder toBuilder() =>
      BuyerAnalyticsProductDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAnalyticsProductDetail &&
        audience == other.audience &&
        scope == other.scope &&
        sourceKind == other.sourceKind &&
        dataset == other.dataset &&
        window == other.window &&
        currentAsOf == other.currentAsOf &&
        snapshot == other.snapshot &&
        updateSchedule == other.updateSchedule &&
        explanation == other.explanation &&
        product == other.product &&
        featured == other.featured &&
        variants == other.variants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, sourceKind.hashCode);
    _$hash = $jc(_$hash, dataset.hashCode);
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, snapshot.hashCode);
    _$hash = $jc(_$hash, updateSchedule.hashCode);
    _$hash = $jc(_$hash, explanation.hashCode);
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jc(_$hash, featured.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAnalyticsProductDetail')
          ..add('audience', audience)
          ..add('scope', scope)
          ..add('sourceKind', sourceKind)
          ..add('dataset', dataset)
          ..add('window', window)
          ..add('currentAsOf', currentAsOf)
          ..add('snapshot', snapshot)
          ..add('updateSchedule', updateSchedule)
          ..add('explanation', explanation)
          ..add('product', product)
          ..add('featured', featured)
          ..add('variants', variants))
        .toString();
  }
}

class BuyerAnalyticsProductDetailBuilder
    implements
        Builder<BuyerAnalyticsProductDetail,
            BuyerAnalyticsProductDetailBuilder> {
  _$BuyerAnalyticsProductDetail? _$v;

  BuyerAnalyticsProductDetailAudienceEnum? _audience;
  BuyerAnalyticsProductDetailAudienceEnum? get audience => _$this._audience;
  set audience(BuyerAnalyticsProductDetailAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  BuyerAnalyticsProductDetailSourceKindEnum? _sourceKind;
  BuyerAnalyticsProductDetailSourceKindEnum? get sourceKind =>
      _$this._sourceKind;
  set sourceKind(BuyerAnalyticsProductDetailSourceKindEnum? sourceKind) =>
      _$this._sourceKind = sourceKind;

  DatasetLabelBuilder? _dataset;
  DatasetLabelBuilder get dataset => _$this._dataset ??= DatasetLabelBuilder();
  set dataset(DatasetLabelBuilder? dataset) => _$this._dataset = dataset;

  AnalyticsWindowBuilder? _window;
  AnalyticsWindowBuilder get window =>
      _$this._window ??= AnalyticsWindowBuilder();
  set window(AnalyticsWindowBuilder? window) => _$this._window = window;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  AnalyticsSnapshotRefBuilder? _snapshot;
  AnalyticsSnapshotRefBuilder get snapshot =>
      _$this._snapshot ??= AnalyticsSnapshotRefBuilder();
  set snapshot(AnalyticsSnapshotRefBuilder? snapshot) =>
      _$this._snapshot = snapshot;

  String? _updateSchedule;
  String? get updateSchedule => _$this._updateSchedule;
  set updateSchedule(String? updateSchedule) =>
      _$this._updateSchedule = updateSchedule;

  String? _explanation;
  String? get explanation => _$this._explanation;
  set explanation(String? explanation) => _$this._explanation = explanation;

  BuyerAnalyticsProductDetailProductBuilder? _product;
  BuyerAnalyticsProductDetailProductBuilder get product =>
      _$this._product ??= BuyerAnalyticsProductDetailProductBuilder();
  set product(BuyerAnalyticsProductDetailProductBuilder? product) =>
      _$this._product = product;

  BuyerAnalyticsFeaturedVariantBuilder? _featured;
  BuyerAnalyticsFeaturedVariantBuilder get featured =>
      _$this._featured ??= BuyerAnalyticsFeaturedVariantBuilder();
  set featured(BuyerAnalyticsFeaturedVariantBuilder? featured) =>
      _$this._featured = featured;

  ListBuilder<BuyerAnalyticsProductVariant>? _variants;
  ListBuilder<BuyerAnalyticsProductVariant> get variants =>
      _$this._variants ??= ListBuilder<BuyerAnalyticsProductVariant>();
  set variants(ListBuilder<BuyerAnalyticsProductVariant>? variants) =>
      _$this._variants = variants;

  BuyerAnalyticsProductDetailBuilder() {
    BuyerAnalyticsProductDetail._defaults(this);
  }

  BuyerAnalyticsProductDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audience = $v.audience;
      _scope = $v.scope.toBuilder();
      _sourceKind = $v.sourceKind;
      _dataset = $v.dataset.toBuilder();
      _window = $v.window.toBuilder();
      _currentAsOf = $v.currentAsOf;
      _snapshot = $v.snapshot?.toBuilder();
      _updateSchedule = $v.updateSchedule;
      _explanation = $v.explanation;
      _product = $v.product.toBuilder();
      _featured = $v.featured?.toBuilder();
      _variants = $v.variants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAnalyticsProductDetail other) {
    _$v = other as _$BuyerAnalyticsProductDetail;
  }

  @override
  void update(void Function(BuyerAnalyticsProductDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAnalyticsProductDetail build() => _build();

  _$BuyerAnalyticsProductDetail _build() {
    _$BuyerAnalyticsProductDetail _$result;
    try {
      _$result = _$v ??
          _$BuyerAnalyticsProductDetail._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'BuyerAnalyticsProductDetail', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'BuyerAnalyticsProductDetail', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'BuyerAnalyticsProductDetail', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule,
                r'BuyerAnalyticsProductDetail',
                'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'BuyerAnalyticsProductDetail', 'explanation'),
            product: product.build(),
            featured: _featured?.build(),
            variants: variants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        scope.build();

        _$failedField = 'dataset';
        dataset.build();
        _$failedField = 'window';
        window.build();

        _$failedField = 'snapshot';
        _snapshot?.build();

        _$failedField = 'product';
        product.build();
        _$failedField = 'featured';
        _featured?.build();
        _$failedField = 'variants';
        variants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerAnalyticsProductDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
