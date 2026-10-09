// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_active_users.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoActiveUsers extends GeoActiveUsers {
  @override
  final GeoCell dau;
  @override
  final GeoCell wau;
  @override
  final GeoCell mau;

  factory _$GeoActiveUsers([void Function(GeoActiveUsersBuilder)? updates]) =>
      (GeoActiveUsersBuilder()..update(updates))._build();

  _$GeoActiveUsers._({required this.dau, required this.wau, required this.mau})
      : super._();
  @override
  GeoActiveUsers rebuild(void Function(GeoActiveUsersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoActiveUsersBuilder toBuilder() => GeoActiveUsersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoActiveUsers &&
        dau == other.dau &&
        wau == other.wau &&
        mau == other.mau;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dau.hashCode);
    _$hash = $jc(_$hash, wau.hashCode);
    _$hash = $jc(_$hash, mau.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoActiveUsers')
          ..add('dau', dau)
          ..add('wau', wau)
          ..add('mau', mau))
        .toString();
  }
}

class GeoActiveUsersBuilder
    implements Builder<GeoActiveUsers, GeoActiveUsersBuilder> {
  _$GeoActiveUsers? _$v;

  GeoCellBuilder? _dau;
  GeoCellBuilder get dau => _$this._dau ??= GeoCellBuilder();
  set dau(GeoCellBuilder? dau) => _$this._dau = dau;

  GeoCellBuilder? _wau;
  GeoCellBuilder get wau => _$this._wau ??= GeoCellBuilder();
  set wau(GeoCellBuilder? wau) => _$this._wau = wau;

  GeoCellBuilder? _mau;
  GeoCellBuilder get mau => _$this._mau ??= GeoCellBuilder();
  set mau(GeoCellBuilder? mau) => _$this._mau = mau;

  GeoActiveUsersBuilder() {
    GeoActiveUsers._defaults(this);
  }

  GeoActiveUsersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dau = $v.dau.toBuilder();
      _wau = $v.wau.toBuilder();
      _mau = $v.mau.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoActiveUsers other) {
    _$v = other as _$GeoActiveUsers;
  }

  @override
  void update(void Function(GeoActiveUsersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoActiveUsers build() => _build();

  _$GeoActiveUsers _build() {
    _$GeoActiveUsers _$result;
    try {
      _$result = _$v ??
          _$GeoActiveUsers._(
            dau: dau.build(),
            wau: wau.build(),
            mau: mau.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dau';
        dau.build();
        _$failedField = 'wau';
        wau.build();
        _$failedField = 'mau';
        mau.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoActiveUsers', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
