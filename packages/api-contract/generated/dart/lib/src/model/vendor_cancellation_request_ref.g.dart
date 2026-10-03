// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_cancellation_request_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorCancellationRequestRef extends VendorCancellationRequestRef {
  @override
  final String reasonCode;
  @override
  final String? reason;
  @override
  final DateTime? requestedAt;
  @override
  final DateTime? responseDueAt;
  @override
  final String orderStateAtRequest;

  factory _$VendorCancellationRequestRef(
          [void Function(VendorCancellationRequestRefBuilder)? updates]) =>
      (VendorCancellationRequestRefBuilder()..update(updates))._build();

  _$VendorCancellationRequestRef._(
      {required this.reasonCode,
      this.reason,
      this.requestedAt,
      this.responseDueAt,
      required this.orderStateAtRequest})
      : super._();
  @override
  VendorCancellationRequestRef rebuild(
          void Function(VendorCancellationRequestRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCancellationRequestRefBuilder toBuilder() =>
      VendorCancellationRequestRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCancellationRequestRef &&
        reasonCode == other.reasonCode &&
        reason == other.reason &&
        requestedAt == other.requestedAt &&
        responseDueAt == other.responseDueAt &&
        orderStateAtRequest == other.orderStateAtRequest;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, responseDueAt.hashCode);
    _$hash = $jc(_$hash, orderStateAtRequest.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCancellationRequestRef')
          ..add('reasonCode', reasonCode)
          ..add('reason', reason)
          ..add('requestedAt', requestedAt)
          ..add('responseDueAt', responseDueAt)
          ..add('orderStateAtRequest', orderStateAtRequest))
        .toString();
  }
}

class VendorCancellationRequestRefBuilder
    implements
        Builder<VendorCancellationRequestRef,
            VendorCancellationRequestRefBuilder> {
  _$VendorCancellationRequestRef? _$v;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _responseDueAt;
  DateTime? get responseDueAt => _$this._responseDueAt;
  set responseDueAt(DateTime? responseDueAt) =>
      _$this._responseDueAt = responseDueAt;

  String? _orderStateAtRequest;
  String? get orderStateAtRequest => _$this._orderStateAtRequest;
  set orderStateAtRequest(String? orderStateAtRequest) =>
      _$this._orderStateAtRequest = orderStateAtRequest;

  VendorCancellationRequestRefBuilder() {
    VendorCancellationRequestRef._defaults(this);
  }

  VendorCancellationRequestRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasonCode = $v.reasonCode;
      _reason = $v.reason;
      _requestedAt = $v.requestedAt;
      _responseDueAt = $v.responseDueAt;
      _orderStateAtRequest = $v.orderStateAtRequest;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCancellationRequestRef other) {
    _$v = other as _$VendorCancellationRequestRef;
  }

  @override
  void update(void Function(VendorCancellationRequestRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCancellationRequestRef build() => _build();

  _$VendorCancellationRequestRef _build() {
    final _$result = _$v ??
        _$VendorCancellationRequestRef._(
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'VendorCancellationRequestRef', 'reasonCode'),
          reason: reason,
          requestedAt: requestedAt,
          responseDueAt: responseDueAt,
          orderStateAtRequest: BuiltValueNullFieldError.checkNotNull(
              orderStateAtRequest,
              r'VendorCancellationRequestRef',
              'orderStateAtRequest'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
