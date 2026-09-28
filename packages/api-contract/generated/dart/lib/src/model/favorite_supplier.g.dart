// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_supplier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FavoriteSupplier extends FavoriteSupplier {
  @override
  final String vendorId;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final ScoreLabel scoreLabel;
  @override
  final bool currentlyDiscoverable;
  @override
  final DateTime savedAt;

  factory _$FavoriteSupplier(
          [void Function(FavoriteSupplierBuilder)? updates]) =>
      (FavoriteSupplierBuilder()..update(updates))._build();

  _$FavoriteSupplier._(
      {required this.vendorId,
      required this.name,
      this.logoUrl,
      required this.scoreLabel,
      required this.currentlyDiscoverable,
      required this.savedAt})
      : super._();
  @override
  FavoriteSupplier rebuild(void Function(FavoriteSupplierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavoriteSupplierBuilder toBuilder() =>
      FavoriteSupplierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavoriteSupplier &&
        vendorId == other.vendorId &&
        name == other.name &&
        logoUrl == other.logoUrl &&
        scoreLabel == other.scoreLabel &&
        currentlyDiscoverable == other.currentlyDiscoverable &&
        savedAt == other.savedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, scoreLabel.hashCode);
    _$hash = $jc(_$hash, currentlyDiscoverable.hashCode);
    _$hash = $jc(_$hash, savedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FavoriteSupplier')
          ..add('vendorId', vendorId)
          ..add('name', name)
          ..add('logoUrl', logoUrl)
          ..add('scoreLabel', scoreLabel)
          ..add('currentlyDiscoverable', currentlyDiscoverable)
          ..add('savedAt', savedAt))
        .toString();
  }
}

class FavoriteSupplierBuilder
    implements Builder<FavoriteSupplier, FavoriteSupplierBuilder> {
  _$FavoriteSupplier? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  ScoreLabelBuilder? _scoreLabel;
  ScoreLabelBuilder get scoreLabel =>
      _$this._scoreLabel ??= ScoreLabelBuilder();
  set scoreLabel(ScoreLabelBuilder? scoreLabel) =>
      _$this._scoreLabel = scoreLabel;

  bool? _currentlyDiscoverable;
  bool? get currentlyDiscoverable => _$this._currentlyDiscoverable;
  set currentlyDiscoverable(bool? currentlyDiscoverable) =>
      _$this._currentlyDiscoverable = currentlyDiscoverable;

  DateTime? _savedAt;
  DateTime? get savedAt => _$this._savedAt;
  set savedAt(DateTime? savedAt) => _$this._savedAt = savedAt;

  FavoriteSupplierBuilder() {
    FavoriteSupplier._defaults(this);
  }

  FavoriteSupplierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _name = $v.name;
      _logoUrl = $v.logoUrl;
      _scoreLabel = $v.scoreLabel.toBuilder();
      _currentlyDiscoverable = $v.currentlyDiscoverable;
      _savedAt = $v.savedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FavoriteSupplier other) {
    _$v = other as _$FavoriteSupplier;
  }

  @override
  void update(void Function(FavoriteSupplierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FavoriteSupplier build() => _build();

  _$FavoriteSupplier _build() {
    _$FavoriteSupplier _$result;
    try {
      _$result = _$v ??
          _$FavoriteSupplier._(
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'FavoriteSupplier', 'vendorId'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'FavoriteSupplier', 'name'),
            logoUrl: logoUrl,
            scoreLabel: scoreLabel.build(),
            currentlyDiscoverable: BuiltValueNullFieldError.checkNotNull(
                currentlyDiscoverable,
                r'FavoriteSupplier',
                'currentlyDiscoverable'),
            savedAt: BuiltValueNullFieldError.checkNotNull(
                savedAt, r'FavoriteSupplier', 'savedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scoreLabel';
        scoreLabel.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FavoriteSupplier', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
