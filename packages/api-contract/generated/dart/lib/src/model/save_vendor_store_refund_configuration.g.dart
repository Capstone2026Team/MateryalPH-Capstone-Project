// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_vendor_store_refund_configuration.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveVendorStoreRefundConfiguration
    extends SaveVendorStoreRefundConfiguration {
  @override
  final bool onlineRefundSupported;
  @override
  final bool physicalReimbursementSupported;

  factory _$SaveVendorStoreRefundConfiguration(
          [void Function(SaveVendorStoreRefundConfigurationBuilder)?
              updates]) =>
      (SaveVendorStoreRefundConfigurationBuilder()..update(updates))._build();

  _$SaveVendorStoreRefundConfiguration._(
      {required this.onlineRefundSupported,
      required this.physicalReimbursementSupported})
      : super._();
  @override
  SaveVendorStoreRefundConfiguration rebuild(
          void Function(SaveVendorStoreRefundConfigurationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SaveVendorStoreRefundConfigurationBuilder toBuilder() =>
      SaveVendorStoreRefundConfigurationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveVendorStoreRefundConfiguration &&
        onlineRefundSupported == other.onlineRefundSupported &&
        physicalReimbursementSupported == other.physicalReimbursementSupported;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, onlineRefundSupported.hashCode);
    _$hash = $jc(_$hash, physicalReimbursementSupported.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveVendorStoreRefundConfiguration')
          ..add('onlineRefundSupported', onlineRefundSupported)
          ..add(
              'physicalReimbursementSupported', physicalReimbursementSupported))
        .toString();
  }
}

class SaveVendorStoreRefundConfigurationBuilder
    implements
        Builder<SaveVendorStoreRefundConfiguration,
            SaveVendorStoreRefundConfigurationBuilder> {
  _$SaveVendorStoreRefundConfiguration? _$v;

  bool? _onlineRefundSupported;
  bool? get onlineRefundSupported => _$this._onlineRefundSupported;
  set onlineRefundSupported(bool? onlineRefundSupported) =>
      _$this._onlineRefundSupported = onlineRefundSupported;

  bool? _physicalReimbursementSupported;
  bool? get physicalReimbursementSupported =>
      _$this._physicalReimbursementSupported;
  set physicalReimbursementSupported(bool? physicalReimbursementSupported) =>
      _$this._physicalReimbursementSupported = physicalReimbursementSupported;

  SaveVendorStoreRefundConfigurationBuilder() {
    SaveVendorStoreRefundConfiguration._defaults(this);
  }

  SaveVendorStoreRefundConfigurationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _onlineRefundSupported = $v.onlineRefundSupported;
      _physicalReimbursementSupported = $v.physicalReimbursementSupported;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveVendorStoreRefundConfiguration other) {
    _$v = other as _$SaveVendorStoreRefundConfiguration;
  }

  @override
  void update(
      void Function(SaveVendorStoreRefundConfigurationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveVendorStoreRefundConfiguration build() => _build();

  _$SaveVendorStoreRefundConfiguration _build() {
    final _$result = _$v ??
        _$SaveVendorStoreRefundConfiguration._(
          onlineRefundSupported: BuiltValueNullFieldError.checkNotNull(
              onlineRefundSupported,
              r'SaveVendorStoreRefundConfiguration',
              'onlineRefundSupported'),
          physicalReimbursementSupported: BuiltValueNullFieldError.checkNotNull(
              physicalReimbursementSupported,
              r'SaveVendorStoreRefundConfiguration',
              'physicalReimbursementSupported'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
