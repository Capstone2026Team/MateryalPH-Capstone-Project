// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_kpis_active_users.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoKpisActiveUsers extends GeoKpisActiveUsers {
  @override
  final GeoActiveUsers buyer;
  @override
  final GeoActiveUsers vendor;

  factory _$GeoKpisActiveUsers(
          [void Function(GeoKpisActiveUsersBuilder)? updates]) =>
      (GeoKpisActiveUsersBuilder()..update(updates))._build();

  _$GeoKpisActiveUsers._({required this.buyer, required this.vendor})
      : super._();
  @override
  GeoKpisActiveUsers rebuild(
          void Function(GeoKpisActiveUsersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoKpisActiveUsersBuilder toBuilder() =>
      GeoKpisActiveUsersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoKpisActiveUsers &&
        buyer == other.buyer &&
        vendor == other.vendor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, buyer.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoKpisActiveUsers')
          ..add('buyer', buyer)
          ..add('vendor', vendor))
        .toString();
  }
}

class GeoKpisActiveUsersBuilder
    implements Builder<GeoKpisActiveUsers, GeoKpisActiveUsersBuilder> {
  _$GeoKpisActiveUsers? _$v;

  GeoActiveUsersBuilder? _buyer;
  GeoActiveUsersBuilder get buyer => _$this._buyer ??= GeoActiveUsersBuilder();
  set buyer(GeoActiveUsersBuilder? buyer) => _$this._buyer = buyer;

  GeoActiveUsersBuilder? _vendor;
  GeoActiveUsersBuilder get vendor =>
      _$this._vendor ??= GeoActiveUsersBuilder();
  set vendor(GeoActiveUsersBuilder? vendor) => _$this._vendor = vendor;

  GeoKpisActiveUsersBuilder() {
    GeoKpisActiveUsers._defaults(this);
  }

  GeoKpisActiveUsersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _buyer = $v.buyer.toBuilder();
      _vendor = $v.vendor.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoKpisActiveUsers other) {
    _$v = other as _$GeoKpisActiveUsers;
  }

  @override
  void update(void Function(GeoKpisActiveUsersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoKpisActiveUsers build() => _build();

  _$GeoKpisActiveUsers _build() {
    _$GeoKpisActiveUsers _$result;
    try {
      _$result = _$v ??
          _$GeoKpisActiveUsers._(
            buyer: buyer.build(),
            vendor: vendor.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'buyer';
        buyer.build();
        _$failedField = 'vendor';
        vendor.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoKpisActiveUsers', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
