// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_receipt.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportReceipt extends SupportReceipt {
  @override
  final String id;
  @override
  final String ticketNumber;
  @override
  final SupportStatus status;

  factory _$SupportReceipt([void Function(SupportReceiptBuilder)? updates]) =>
      (SupportReceiptBuilder()..update(updates))._build();

  _$SupportReceipt._(
      {required this.id, required this.ticketNumber, required this.status})
      : super._();
  @override
  SupportReceipt rebuild(void Function(SupportReceiptBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportReceiptBuilder toBuilder() => SupportReceiptBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportReceipt &&
        id == other.id &&
        ticketNumber == other.ticketNumber &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ticketNumber.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportReceipt')
          ..add('id', id)
          ..add('ticketNumber', ticketNumber)
          ..add('status', status))
        .toString();
  }
}

class SupportReceiptBuilder
    implements Builder<SupportReceipt, SupportReceiptBuilder> {
  _$SupportReceipt? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _ticketNumber;
  String? get ticketNumber => _$this._ticketNumber;
  set ticketNumber(String? ticketNumber) => _$this._ticketNumber = ticketNumber;

  SupportStatus? _status;
  SupportStatus? get status => _$this._status;
  set status(SupportStatus? status) => _$this._status = status;

  SupportReceiptBuilder() {
    SupportReceipt._defaults(this);
  }

  SupportReceiptBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ticketNumber = $v.ticketNumber;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportReceipt other) {
    _$v = other as _$SupportReceipt;
  }

  @override
  void update(void Function(SupportReceiptBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportReceipt build() => _build();

  _$SupportReceipt _build() {
    final _$result = _$v ??
        _$SupportReceipt._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SupportReceipt', 'id'),
          ticketNumber: BuiltValueNullFieldError.checkNotNull(
              ticketNumber, r'SupportReceipt', 'ticketNumber'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SupportReceipt', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
