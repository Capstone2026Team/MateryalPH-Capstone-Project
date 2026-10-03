// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancellation_request_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCancellationRequestRow extends AdminCancellationRequestRow {
  @override
  final String id;
  @override
  final String orderReference;
  @override
  final String? vendorName;
  @override
  final String reasonCode;
  @override
  final DateTime? requestedAt;
  @override
  final DateTime? responseDueAt;
  @override
  final bool overdue;

  factory _$AdminCancellationRequestRow(
          [void Function(AdminCancellationRequestRowBuilder)? updates]) =>
      (AdminCancellationRequestRowBuilder()..update(updates))._build();

  _$AdminCancellationRequestRow._(
      {required this.id,
      required this.orderReference,
      this.vendorName,
      required this.reasonCode,
      this.requestedAt,
      this.responseDueAt,
      required this.overdue})
      : super._();
  @override
  AdminCancellationRequestRow rebuild(
          void Function(AdminCancellationRequestRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminCancellationRequestRowBuilder toBuilder() =>
      AdminCancellationRequestRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancellationRequestRow &&
        id == other.id &&
        orderReference == other.orderReference &&
        vendorName == other.vendorName &&
        reasonCode == other.reasonCode &&
        requestedAt == other.requestedAt &&
        responseDueAt == other.responseDueAt &&
        overdue == other.overdue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, responseDueAt.hashCode);
    _$hash = $jc(_$hash, overdue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCancellationRequestRow')
          ..add('id', id)
          ..add('orderReference', orderReference)
          ..add('vendorName', vendorName)
          ..add('reasonCode', reasonCode)
          ..add('requestedAt', requestedAt)
          ..add('responseDueAt', responseDueAt)
          ..add('overdue', overdue))
        .toString();
  }
}

class AdminCancellationRequestRowBuilder
    implements
        Builder<AdminCancellationRequestRow,
            AdminCancellationRequestRowBuilder> {
  _$AdminCancellationRequestRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _responseDueAt;
  DateTime? get responseDueAt => _$this._responseDueAt;
  set responseDueAt(DateTime? responseDueAt) =>
      _$this._responseDueAt = responseDueAt;

  bool? _overdue;
  bool? get overdue => _$this._overdue;
  set overdue(bool? overdue) => _$this._overdue = overdue;

  AdminCancellationRequestRowBuilder() {
    AdminCancellationRequestRow._defaults(this);
  }

  AdminCancellationRequestRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderReference = $v.orderReference;
      _vendorName = $v.vendorName;
      _reasonCode = $v.reasonCode;
      _requestedAt = $v.requestedAt;
      _responseDueAt = $v.responseDueAt;
      _overdue = $v.overdue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancellationRequestRow other) {
    _$v = other as _$AdminCancellationRequestRow;
  }

  @override
  void update(void Function(AdminCancellationRequestRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancellationRequestRow build() => _build();

  _$AdminCancellationRequestRow _build() {
    final _$result = _$v ??
        _$AdminCancellationRequestRow._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminCancellationRequestRow', 'id'),
          orderReference: BuiltValueNullFieldError.checkNotNull(
              orderReference, r'AdminCancellationRequestRow', 'orderReference'),
          vendorName: vendorName,
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'AdminCancellationRequestRow', 'reasonCode'),
          requestedAt: requestedAt,
          responseDueAt: responseDueAt,
          overdue: BuiltValueNullFieldError.checkNotNull(
              overdue, r'AdminCancellationRequestRow', 'overdue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
