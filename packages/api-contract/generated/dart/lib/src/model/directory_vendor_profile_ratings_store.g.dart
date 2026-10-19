// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_profile_ratings_store.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryVendorProfileRatingsStore
    extends DirectoryVendorProfileRatingsStore {
  @override
  final int count;
  @override
  final String? serviceQuality;
  @override
  final String? speed;

  factory _$DirectoryVendorProfileRatingsStore(
          [void Function(DirectoryVendorProfileRatingsStoreBuilder)?
              updates]) =>
      (DirectoryVendorProfileRatingsStoreBuilder()..update(updates))._build();

  _$DirectoryVendorProfileRatingsStore._(
      {required this.count, this.serviceQuality, this.speed})
      : super._();
  @override
  DirectoryVendorProfileRatingsStore rebuild(
          void Function(DirectoryVendorProfileRatingsStoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorProfileRatingsStoreBuilder toBuilder() =>
      DirectoryVendorProfileRatingsStoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorProfileRatingsStore &&
        count == other.count &&
        serviceQuality == other.serviceQuality &&
        speed == other.speed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, serviceQuality.hashCode);
    _$hash = $jc(_$hash, speed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryVendorProfileRatingsStore')
          ..add('count', count)
          ..add('serviceQuality', serviceQuality)
          ..add('speed', speed))
        .toString();
  }
}

class DirectoryVendorProfileRatingsStoreBuilder
    implements
        Builder<DirectoryVendorProfileRatingsStore,
            DirectoryVendorProfileRatingsStoreBuilder> {
  _$DirectoryVendorProfileRatingsStore? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _serviceQuality;
  String? get serviceQuality => _$this._serviceQuality;
  set serviceQuality(String? serviceQuality) =>
      _$this._serviceQuality = serviceQuality;

  String? _speed;
  String? get speed => _$this._speed;
  set speed(String? speed) => _$this._speed = speed;

  DirectoryVendorProfileRatingsStoreBuilder() {
    DirectoryVendorProfileRatingsStore._defaults(this);
  }

  DirectoryVendorProfileRatingsStoreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _serviceQuality = $v.serviceQuality;
      _speed = $v.speed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryVendorProfileRatingsStore other) {
    _$v = other as _$DirectoryVendorProfileRatingsStore;
  }

  @override
  void update(
      void Function(DirectoryVendorProfileRatingsStoreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorProfileRatingsStore build() => _build();

  _$DirectoryVendorProfileRatingsStore _build() {
    final _$result = _$v ??
        _$DirectoryVendorProfileRatingsStore._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'DirectoryVendorProfileRatingsStore', 'count'),
          serviceQuality: serviceQuality,
          speed: speed,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
