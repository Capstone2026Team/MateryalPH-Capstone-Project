// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_preview_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutPreviewRequest extends CheckoutPreviewRequest {
  @override
  final String? requestVersion;

  factory _$CheckoutPreviewRequest(
          [void Function(CheckoutPreviewRequestBuilder)? updates]) =>
      (CheckoutPreviewRequestBuilder()..update(updates))._build();

  _$CheckoutPreviewRequest._({this.requestVersion}) : super._();
  @override
  CheckoutPreviewRequest rebuild(
          void Function(CheckoutPreviewRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutPreviewRequestBuilder toBuilder() =>
      CheckoutPreviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutPreviewRequest &&
        requestVersion == other.requestVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requestVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutPreviewRequest')
          ..add('requestVersion', requestVersion))
        .toString();
  }
}

class CheckoutPreviewRequestBuilder
    implements Builder<CheckoutPreviewRequest, CheckoutPreviewRequestBuilder> {
  _$CheckoutPreviewRequest? _$v;

  String? _requestVersion;
  String? get requestVersion => _$this._requestVersion;
  set requestVersion(String? requestVersion) =>
      _$this._requestVersion = requestVersion;

  CheckoutPreviewRequestBuilder() {
    CheckoutPreviewRequest._defaults(this);
  }

  CheckoutPreviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requestVersion = $v.requestVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutPreviewRequest other) {
    _$v = other as _$CheckoutPreviewRequest;
  }

  @override
  void update(void Function(CheckoutPreviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutPreviewRequest build() => _build();

  _$CheckoutPreviewRequest _build() {
    final _$result = _$v ??
        _$CheckoutPreviewRequest._(
          requestVersion: requestVersion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
