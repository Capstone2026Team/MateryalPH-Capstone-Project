// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_submit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutSubmitRequest extends CheckoutSubmitRequest {
  @override
  final int cartLockVersion;
  @override
  final BuiltSet<String> vendorIds;
  @override
  final bool? splitConfirmed;

  factory _$CheckoutSubmitRequest(
          [void Function(CheckoutSubmitRequestBuilder)? updates]) =>
      (CheckoutSubmitRequestBuilder()..update(updates))._build();

  _$CheckoutSubmitRequest._(
      {required this.cartLockVersion,
      required this.vendorIds,
      this.splitConfirmed})
      : super._();
  @override
  CheckoutSubmitRequest rebuild(
          void Function(CheckoutSubmitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutSubmitRequestBuilder toBuilder() =>
      CheckoutSubmitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutSubmitRequest &&
        cartLockVersion == other.cartLockVersion &&
        vendorIds == other.vendorIds &&
        splitConfirmed == other.splitConfirmed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cartLockVersion.hashCode);
    _$hash = $jc(_$hash, vendorIds.hashCode);
    _$hash = $jc(_$hash, splitConfirmed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutSubmitRequest')
          ..add('cartLockVersion', cartLockVersion)
          ..add('vendorIds', vendorIds)
          ..add('splitConfirmed', splitConfirmed))
        .toString();
  }
}

class CheckoutSubmitRequestBuilder
    implements Builder<CheckoutSubmitRequest, CheckoutSubmitRequestBuilder> {
  _$CheckoutSubmitRequest? _$v;

  int? _cartLockVersion;
  int? get cartLockVersion => _$this._cartLockVersion;
  set cartLockVersion(int? cartLockVersion) =>
      _$this._cartLockVersion = cartLockVersion;

  SetBuilder<String>? _vendorIds;
  SetBuilder<String> get vendorIds =>
      _$this._vendorIds ??= SetBuilder<String>();
  set vendorIds(SetBuilder<String>? vendorIds) => _$this._vendorIds = vendorIds;

  bool? _splitConfirmed;
  bool? get splitConfirmed => _$this._splitConfirmed;
  set splitConfirmed(bool? splitConfirmed) =>
      _$this._splitConfirmed = splitConfirmed;

  CheckoutSubmitRequestBuilder() {
    CheckoutSubmitRequest._defaults(this);
  }

  CheckoutSubmitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cartLockVersion = $v.cartLockVersion;
      _vendorIds = $v.vendorIds.toBuilder();
      _splitConfirmed = $v.splitConfirmed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutSubmitRequest other) {
    _$v = other as _$CheckoutSubmitRequest;
  }

  @override
  void update(void Function(CheckoutSubmitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutSubmitRequest build() => _build();

  _$CheckoutSubmitRequest _build() {
    _$CheckoutSubmitRequest _$result;
    try {
      _$result = _$v ??
          _$CheckoutSubmitRequest._(
            cartLockVersion: BuiltValueNullFieldError.checkNotNull(
                cartLockVersion, r'CheckoutSubmitRequest', 'cartLockVersion'),
            vendorIds: vendorIds.build(),
            splitConfirmed: splitConfirmed,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendorIds';
        vendorIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckoutSubmitRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
