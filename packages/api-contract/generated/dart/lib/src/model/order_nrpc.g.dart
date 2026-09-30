// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_nrpc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderNrpcStatusEnum _$orderNrpcStatusEnum_PROPOSED =
    const OrderNrpcStatusEnum._('PROPOSED');
const OrderNrpcStatusEnum _$orderNrpcStatusEnum_ACCEPTED =
    const OrderNrpcStatusEnum._('ACCEPTED');
const OrderNrpcStatusEnum _$orderNrpcStatusEnum_REJECTED =
    const OrderNrpcStatusEnum._('REJECTED');

OrderNrpcStatusEnum _$orderNrpcStatusEnumValueOf(String name) {
  switch (name) {
    case 'PROPOSED':
      return _$orderNrpcStatusEnum_PROPOSED;
    case 'ACCEPTED':
      return _$orderNrpcStatusEnum_ACCEPTED;
    case 'REJECTED':
      return _$orderNrpcStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderNrpcStatusEnum> _$orderNrpcStatusEnumValues =
    BuiltSet<OrderNrpcStatusEnum>(const <OrderNrpcStatusEnum>[
  _$orderNrpcStatusEnum_PROPOSED,
  _$orderNrpcStatusEnum_ACCEPTED,
  _$orderNrpcStatusEnum_REJECTED,
]);

Serializer<OrderNrpcStatusEnum> _$orderNrpcStatusEnumSerializer =
    _$OrderNrpcStatusEnumSerializer();

class _$OrderNrpcStatusEnumSerializer
    implements PrimitiveSerializer<OrderNrpcStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PROPOSED': 'PROPOSED',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PROPOSED': 'PROPOSED',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderNrpcStatusEnum];
  @override
  final String wireName = 'OrderNrpcStatusEnum';

  @override
  Object serialize(Serializers serializers, OrderNrpcStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderNrpcStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderNrpcStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderNrpc extends OrderNrpc {
  @override
  final String id;
  @override
  final int amountCentavos;
  @override
  final String reason;
  @override
  final int? eligibleSubtotalCentavos;
  @override
  final int snapshotVersion;
  @override
  final DateTime? proposedAt;
  @override
  final BuiltList<NrpcAffectedLine> affectedLines;
  @override
  final NrpcTermsVersion? terms;
  @override
  final String cancellationEffect;
  @override
  final OrderNrpcStatusEnum status;
  @override
  final DateTime? acceptedAt;
  @override
  final NrpcFlag? flag;

  factory _$OrderNrpc([void Function(OrderNrpcBuilder)? updates]) =>
      (OrderNrpcBuilder()..update(updates))._build();

  _$OrderNrpc._(
      {required this.id,
      required this.amountCentavos,
      required this.reason,
      this.eligibleSubtotalCentavos,
      required this.snapshotVersion,
      this.proposedAt,
      required this.affectedLines,
      this.terms,
      required this.cancellationEffect,
      required this.status,
      this.acceptedAt,
      this.flag})
      : super._();
  @override
  OrderNrpc rebuild(void Function(OrderNrpcBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderNrpcBuilder toBuilder() => OrderNrpcBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderNrpc &&
        id == other.id &&
        amountCentavos == other.amountCentavos &&
        reason == other.reason &&
        eligibleSubtotalCentavos == other.eligibleSubtotalCentavos &&
        snapshotVersion == other.snapshotVersion &&
        proposedAt == other.proposedAt &&
        affectedLines == other.affectedLines &&
        terms == other.terms &&
        cancellationEffect == other.cancellationEffect &&
        status == other.status &&
        acceptedAt == other.acceptedAt &&
        flag == other.flag;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, eligibleSubtotalCentavos.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, proposedAt.hashCode);
    _$hash = $jc(_$hash, affectedLines.hashCode);
    _$hash = $jc(_$hash, terms.hashCode);
    _$hash = $jc(_$hash, cancellationEffect.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jc(_$hash, flag.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderNrpc')
          ..add('id', id)
          ..add('amountCentavos', amountCentavos)
          ..add('reason', reason)
          ..add('eligibleSubtotalCentavos', eligibleSubtotalCentavos)
          ..add('snapshotVersion', snapshotVersion)
          ..add('proposedAt', proposedAt)
          ..add('affectedLines', affectedLines)
          ..add('terms', terms)
          ..add('cancellationEffect', cancellationEffect)
          ..add('status', status)
          ..add('acceptedAt', acceptedAt)
          ..add('flag', flag))
        .toString();
  }
}

class OrderNrpcBuilder implements Builder<OrderNrpc, OrderNrpcBuilder> {
  _$OrderNrpc? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _eligibleSubtotalCentavos;
  int? get eligibleSubtotalCentavos => _$this._eligibleSubtotalCentavos;
  set eligibleSubtotalCentavos(int? eligibleSubtotalCentavos) =>
      _$this._eligibleSubtotalCentavos = eligibleSubtotalCentavos;

  int? _snapshotVersion;
  int? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(int? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  DateTime? _proposedAt;
  DateTime? get proposedAt => _$this._proposedAt;
  set proposedAt(DateTime? proposedAt) => _$this._proposedAt = proposedAt;

  ListBuilder<NrpcAffectedLine>? _affectedLines;
  ListBuilder<NrpcAffectedLine> get affectedLines =>
      _$this._affectedLines ??= ListBuilder<NrpcAffectedLine>();
  set affectedLines(ListBuilder<NrpcAffectedLine>? affectedLines) =>
      _$this._affectedLines = affectedLines;

  NrpcTermsVersionBuilder? _terms;
  NrpcTermsVersionBuilder get terms =>
      _$this._terms ??= NrpcTermsVersionBuilder();
  set terms(NrpcTermsVersionBuilder? terms) => _$this._terms = terms;

  String? _cancellationEffect;
  String? get cancellationEffect => _$this._cancellationEffect;
  set cancellationEffect(String? cancellationEffect) =>
      _$this._cancellationEffect = cancellationEffect;

  OrderNrpcStatusEnum? _status;
  OrderNrpcStatusEnum? get status => _$this._status;
  set status(OrderNrpcStatusEnum? status) => _$this._status = status;

  DateTime? _acceptedAt;
  DateTime? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(DateTime? acceptedAt) => _$this._acceptedAt = acceptedAt;

  NrpcFlagBuilder? _flag;
  NrpcFlagBuilder get flag => _$this._flag ??= NrpcFlagBuilder();
  set flag(NrpcFlagBuilder? flag) => _$this._flag = flag;

  OrderNrpcBuilder() {
    OrderNrpc._defaults(this);
  }

  OrderNrpcBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _amountCentavos = $v.amountCentavos;
      _reason = $v.reason;
      _eligibleSubtotalCentavos = $v.eligibleSubtotalCentavos;
      _snapshotVersion = $v.snapshotVersion;
      _proposedAt = $v.proposedAt;
      _affectedLines = $v.affectedLines.toBuilder();
      _terms = $v.terms?.toBuilder();
      _cancellationEffect = $v.cancellationEffect;
      _status = $v.status;
      _acceptedAt = $v.acceptedAt;
      _flag = $v.flag?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderNrpc other) {
    _$v = other as _$OrderNrpc;
  }

  @override
  void update(void Function(OrderNrpcBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderNrpc build() => _build();

  _$OrderNrpc _build() {
    _$OrderNrpc _$result;
    try {
      _$result = _$v ??
          _$OrderNrpc._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'OrderNrpc', 'id'),
            amountCentavos: BuiltValueNullFieldError.checkNotNull(
                amountCentavos, r'OrderNrpc', 'amountCentavos'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'OrderNrpc', 'reason'),
            eligibleSubtotalCentavos: eligibleSubtotalCentavos,
            snapshotVersion: BuiltValueNullFieldError.checkNotNull(
                snapshotVersion, r'OrderNrpc', 'snapshotVersion'),
            proposedAt: proposedAt,
            affectedLines: affectedLines.build(),
            terms: _terms?.build(),
            cancellationEffect: BuiltValueNullFieldError.checkNotNull(
                cancellationEffect, r'OrderNrpc', 'cancellationEffect'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'OrderNrpc', 'status'),
            acceptedAt: acceptedAt,
            flag: _flag?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'affectedLines';
        affectedLines.build();
        _$failedField = 'terms';
        _terms?.build();

        _$failedField = 'flag';
        _flag?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderNrpc', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
