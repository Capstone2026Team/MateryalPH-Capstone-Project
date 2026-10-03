// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reimbursement_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReimbursementRowStateEnum
    _$adminReimbursementRowStateEnum_VENDOR_REIMBURSEMENT_PENDING =
    const AdminReimbursementRowStateEnum._('VENDOR_REIMBURSEMENT_PENDING');
const AdminReimbursementRowStateEnum
    _$adminReimbursementRowStateEnum_REIMBURSEMENT_CONFIRMED =
    const AdminReimbursementRowStateEnum._('REIMBURSEMENT_CONFIRMED');

AdminReimbursementRowStateEnum _$adminReimbursementRowStateEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR_REIMBURSEMENT_PENDING':
      return _$adminReimbursementRowStateEnum_VENDOR_REIMBURSEMENT_PENDING;
    case 'REIMBURSEMENT_CONFIRMED':
      return _$adminReimbursementRowStateEnum_REIMBURSEMENT_CONFIRMED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReimbursementRowStateEnum>
    _$adminReimbursementRowStateEnumValues = BuiltSet<
        AdminReimbursementRowStateEnum>(const <AdminReimbursementRowStateEnum>[
  _$adminReimbursementRowStateEnum_VENDOR_REIMBURSEMENT_PENDING,
  _$adminReimbursementRowStateEnum_REIMBURSEMENT_CONFIRMED,
]);

Serializer<AdminReimbursementRowStateEnum>
    _$adminReimbursementRowStateEnumSerializer =
    _$AdminReimbursementRowStateEnumSerializer();

class _$AdminReimbursementRowStateEnumSerializer
    implements PrimitiveSerializer<AdminReimbursementRowStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_REIMBURSEMENT_PENDING': 'VENDOR_REIMBURSEMENT_PENDING',
    'REIMBURSEMENT_CONFIRMED': 'REIMBURSEMENT_CONFIRMED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_REIMBURSEMENT_PENDING': 'VENDOR_REIMBURSEMENT_PENDING',
    'REIMBURSEMENT_CONFIRMED': 'REIMBURSEMENT_CONFIRMED',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminReimbursementRowStateEnum];
  @override
  final String wireName = 'AdminReimbursementRowStateEnum';

  @override
  Object serialize(
          Serializers serializers, AdminReimbursementRowStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminReimbursementRowStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminReimbursementRowStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminReimbursementRow extends AdminReimbursementRow {
  @override
  final String id;
  @override
  final String orderReference;
  @override
  final String? vendorName;
  @override
  final AdminReimbursementRowStateEnum state;
  @override
  final int amountCentavos;
  @override
  final String method;
  @override
  final bool hasEvidence;
  @override
  final DateTime? reimbursedAt;
  @override
  final DateTime? buyerAcknowledgedAt;
  @override
  final bool confirmedByReview;
  @override
  final bool canDecide;

  factory _$AdminReimbursementRow(
          [void Function(AdminReimbursementRowBuilder)? updates]) =>
      (AdminReimbursementRowBuilder()..update(updates))._build();

  _$AdminReimbursementRow._(
      {required this.id,
      required this.orderReference,
      this.vendorName,
      required this.state,
      required this.amountCentavos,
      required this.method,
      required this.hasEvidence,
      this.reimbursedAt,
      this.buyerAcknowledgedAt,
      required this.confirmedByReview,
      required this.canDecide})
      : super._();
  @override
  AdminReimbursementRow rebuild(
          void Function(AdminReimbursementRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReimbursementRowBuilder toBuilder() =>
      AdminReimbursementRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReimbursementRow &&
        id == other.id &&
        orderReference == other.orderReference &&
        vendorName == other.vendorName &&
        state == other.state &&
        amountCentavos == other.amountCentavos &&
        method == other.method &&
        hasEvidence == other.hasEvidence &&
        reimbursedAt == other.reimbursedAt &&
        buyerAcknowledgedAt == other.buyerAcknowledgedAt &&
        confirmedByReview == other.confirmedByReview &&
        canDecide == other.canDecide;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, hasEvidence.hashCode);
    _$hash = $jc(_$hash, reimbursedAt.hashCode);
    _$hash = $jc(_$hash, buyerAcknowledgedAt.hashCode);
    _$hash = $jc(_$hash, confirmedByReview.hashCode);
    _$hash = $jc(_$hash, canDecide.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReimbursementRow')
          ..add('id', id)
          ..add('orderReference', orderReference)
          ..add('vendorName', vendorName)
          ..add('state', state)
          ..add('amountCentavos', amountCentavos)
          ..add('method', method)
          ..add('hasEvidence', hasEvidence)
          ..add('reimbursedAt', reimbursedAt)
          ..add('buyerAcknowledgedAt', buyerAcknowledgedAt)
          ..add('confirmedByReview', confirmedByReview)
          ..add('canDecide', canDecide))
        .toString();
  }
}

class AdminReimbursementRowBuilder
    implements Builder<AdminReimbursementRow, AdminReimbursementRowBuilder> {
  _$AdminReimbursementRow? _$v;

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

  AdminReimbursementRowStateEnum? _state;
  AdminReimbursementRowStateEnum? get state => _$this._state;
  set state(AdminReimbursementRowStateEnum? state) => _$this._state = state;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  bool? _hasEvidence;
  bool? get hasEvidence => _$this._hasEvidence;
  set hasEvidence(bool? hasEvidence) => _$this._hasEvidence = hasEvidence;

  DateTime? _reimbursedAt;
  DateTime? get reimbursedAt => _$this._reimbursedAt;
  set reimbursedAt(DateTime? reimbursedAt) =>
      _$this._reimbursedAt = reimbursedAt;

  DateTime? _buyerAcknowledgedAt;
  DateTime? get buyerAcknowledgedAt => _$this._buyerAcknowledgedAt;
  set buyerAcknowledgedAt(DateTime? buyerAcknowledgedAt) =>
      _$this._buyerAcknowledgedAt = buyerAcknowledgedAt;

  bool? _confirmedByReview;
  bool? get confirmedByReview => _$this._confirmedByReview;
  set confirmedByReview(bool? confirmedByReview) =>
      _$this._confirmedByReview = confirmedByReview;

  bool? _canDecide;
  bool? get canDecide => _$this._canDecide;
  set canDecide(bool? canDecide) => _$this._canDecide = canDecide;

  AdminReimbursementRowBuilder() {
    AdminReimbursementRow._defaults(this);
  }

  AdminReimbursementRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderReference = $v.orderReference;
      _vendorName = $v.vendorName;
      _state = $v.state;
      _amountCentavos = $v.amountCentavos;
      _method = $v.method;
      _hasEvidence = $v.hasEvidence;
      _reimbursedAt = $v.reimbursedAt;
      _buyerAcknowledgedAt = $v.buyerAcknowledgedAt;
      _confirmedByReview = $v.confirmedByReview;
      _canDecide = $v.canDecide;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReimbursementRow other) {
    _$v = other as _$AdminReimbursementRow;
  }

  @override
  void update(void Function(AdminReimbursementRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReimbursementRow build() => _build();

  _$AdminReimbursementRow _build() {
    final _$result = _$v ??
        _$AdminReimbursementRow._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminReimbursementRow', 'id'),
          orderReference: BuiltValueNullFieldError.checkNotNull(
              orderReference, r'AdminReimbursementRow', 'orderReference'),
          vendorName: vendorName,
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'AdminReimbursementRow', 'state'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'AdminReimbursementRow', 'amountCentavos'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'AdminReimbursementRow', 'method'),
          hasEvidence: BuiltValueNullFieldError.checkNotNull(
              hasEvidence, r'AdminReimbursementRow', 'hasEvidence'),
          reimbursedAt: reimbursedAt,
          buyerAcknowledgedAt: buyerAcknowledgedAt,
          confirmedByReview: BuiltValueNullFieldError.checkNotNull(
              confirmedByReview, r'AdminReimbursementRow', 'confirmedByReview'),
          canDecide: BuiltValueNullFieldError.checkNotNull(
              canDecide, r'AdminReimbursementRow', 'canDecide'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
