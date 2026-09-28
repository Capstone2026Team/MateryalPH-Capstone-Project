// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_supplier_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FavoriteSupplierState extends FavoriteSupplierState {
  @override
  final String vendorId;
  @override
  final bool isFavorite;

  factory _$FavoriteSupplierState(
          [void Function(FavoriteSupplierStateBuilder)? updates]) =>
      (FavoriteSupplierStateBuilder()..update(updates))._build();

  _$FavoriteSupplierState._({required this.vendorId, required this.isFavorite})
      : super._();
  @override
  FavoriteSupplierState rebuild(
          void Function(FavoriteSupplierStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavoriteSupplierStateBuilder toBuilder() =>
      FavoriteSupplierStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavoriteSupplierState &&
        vendorId == other.vendorId &&
        isFavorite == other.isFavorite;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, isFavorite.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FavoriteSupplierState')
          ..add('vendorId', vendorId)
          ..add('isFavorite', isFavorite))
        .toString();
  }
}

class FavoriteSupplierStateBuilder
    implements Builder<FavoriteSupplierState, FavoriteSupplierStateBuilder> {
  _$FavoriteSupplierState? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  bool? _isFavorite;
  bool? get isFavorite => _$this._isFavorite;
  set isFavorite(bool? isFavorite) => _$this._isFavorite = isFavorite;

  FavoriteSupplierStateBuilder() {
    FavoriteSupplierState._defaults(this);
  }

  FavoriteSupplierStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _isFavorite = $v.isFavorite;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FavoriteSupplierState other) {
    _$v = other as _$FavoriteSupplierState;
  }

  @override
  void update(void Function(FavoriteSupplierStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FavoriteSupplierState build() => _build();

  _$FavoriteSupplierState _build() {
    final _$result = _$v ??
        _$FavoriteSupplierState._(
          vendorId: BuiltValueNullFieldError.checkNotNull(
              vendorId, r'FavoriteSupplierState', 'vendorId'),
          isFavorite: BuiltValueNullFieldError.checkNotNull(
              isFavorite, r'FavoriteSupplierState', 'isFavorite'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
