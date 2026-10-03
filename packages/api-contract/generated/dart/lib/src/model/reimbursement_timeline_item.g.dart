// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reimbursement_timeline_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReimbursementTimelineItemStateEnum
    _$reimbursementTimelineItemStateEnum_VENDOR_REIMBURSEMENT_PENDING =
    const ReimbursementTimelineItemStateEnum._('VENDOR_REIMBURSEMENT_PENDING');
const ReimbursementTimelineItemStateEnum
    _$reimbursementTimelineItemStateEnum_REIMBURSEMENT_CONFIRMED =
    const ReimbursementTimelineItemStateEnum._('REIMBURSEMENT_CONFIRMED');

ReimbursementTimelineItemStateEnum _$reimbursementTimelineItemStateEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR_REIMBURSEMENT_PENDING':
      return _$reimbursementTimelineItemStateEnum_VENDOR_REIMBURSEMENT_PENDING;
    case 'REIMBURSEMENT_CONFIRMED':
      return _$reimbursementTimelineItemStateEnum_REIMBURSEMENT_CONFIRMED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReimbursementTimelineItemStateEnum>
    _$reimbursementTimelineItemStateEnumValues = BuiltSet<
        ReimbursementTimelineItemStateEnum>(const <ReimbursementTimelineItemStateEnum>[
  _$reimbursementTimelineItemStateEnum_VENDOR_REIMBURSEMENT_PENDING,
  _$reimbursementTimelineItemStateEnum_REIMBURSEMENT_CONFIRMED,
]);

Serializer<ReimbursementTimelineItemStateEnum>
    _$reimbursementTimelineItemStateEnumSerializer =
    _$ReimbursementTimelineItemStateEnumSerializer();

class _$ReimbursementTimelineItemStateEnumSerializer
    implements PrimitiveSerializer<ReimbursementTimelineItemStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_REIMBURSEMENT_PENDING': 'VENDOR_REIMBURSEMENT_PENDING',
    'REIMBURSEMENT_CONFIRMED': 'REIMBURSEMENT_CONFIRMED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_REIMBURSEMENT_PENDING': 'VENDOR_REIMBURSEMENT_PENDING',
    'REIMBURSEMENT_CONFIRMED': 'REIMBURSEMENT_CONFIRMED',
  };

  @override
  final Iterable<Type> types = const <Type>[ReimbursementTimelineItemStateEnum];
  @override
  final String wireName = 'ReimbursementTimelineItemStateEnum';

  @override
  Object serialize(
          Serializers serializers, ReimbursementTimelineItemStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReimbursementTimelineItemStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReimbursementTimelineItemStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReimbursementTimelineItem extends ReimbursementTimelineItem {
  @override
  final String id;
  @override
  final ReimbursementTimelineItemStateEnum state;
  @override
  final int amountCentavos;
  @override
  final String method;
  @override
  final DateTime? reimbursedAt;
  @override
  final DateTime? buyerAcknowledgedAt;
  @override
  final bool hasEvidence;
  @override
  final String? evidencePath;
  @override
  final bool confirmedByReview;
  @override
  final String message;

  factory _$ReimbursementTimelineItem(
          [void Function(ReimbursementTimelineItemBuilder)? updates]) =>
      (ReimbursementTimelineItemBuilder()..update(updates))._build();

  _$ReimbursementTimelineItem._(
      {required this.id,
      required this.state,
      required this.amountCentavos,
      required this.method,
      this.reimbursedAt,
      this.buyerAcknowledgedAt,
      required this.hasEvidence,
      this.evidencePath,
      required this.confirmedByReview,
      required this.message})
      : super._();
  @override
  ReimbursementTimelineItem rebuild(
          void Function(ReimbursementTimelineItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReimbursementTimelineItemBuilder toBuilder() =>
      ReimbursementTimelineItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReimbursementTimelineItem &&
        id == other.id &&
        state == other.state &&
        amountCentavos == other.amountCentavos &&
        method == other.method &&
        reimbursedAt == other.reimbursedAt &&
        buyerAcknowledgedAt == other.buyerAcknowledgedAt &&
        hasEvidence == other.hasEvidence &&
        evidencePath == other.evidencePath &&
        confirmedByReview == other.confirmedByReview &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, reimbursedAt.hashCode);
    _$hash = $jc(_$hash, buyerAcknowledgedAt.hashCode);
    _$hash = $jc(_$hash, hasEvidence.hashCode);
    _$hash = $jc(_$hash, evidencePath.hashCode);
    _$hash = $jc(_$hash, confirmedByReview.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReimbursementTimelineItem')
          ..add('id', id)
          ..add('state', state)
          ..add('amountCentavos', amountCentavos)
          ..add('method', method)
          ..add('reimbursedAt', reimbursedAt)
          ..add('buyerAcknowledgedAt', buyerAcknowledgedAt)
          ..add('hasEvidence', hasEvidence)
          ..add('evidencePath', evidencePath)
          ..add('confirmedByReview', confirmedByReview)
          ..add('message', message))
        .toString();
  }
}

class ReimbursementTimelineItemBuilder
    implements
        Builder<ReimbursementTimelineItem, ReimbursementTimelineItemBuilder> {
  _$ReimbursementTimelineItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ReimbursementTimelineItemStateEnum? _state;
  ReimbursementTimelineItemStateEnum? get state => _$this._state;
  set state(ReimbursementTimelineItemStateEnum? state) => _$this._state = state;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  DateTime? _reimbursedAt;
  DateTime? get reimbursedAt => _$this._reimbursedAt;
  set reimbursedAt(DateTime? reimbursedAt) =>
      _$this._reimbursedAt = reimbursedAt;

  DateTime? _buyerAcknowledgedAt;
  DateTime? get buyerAcknowledgedAt => _$this._buyerAcknowledgedAt;
  set buyerAcknowledgedAt(DateTime? buyerAcknowledgedAt) =>
      _$this._buyerAcknowledgedAt = buyerAcknowledgedAt;

  bool? _hasEvidence;
  bool? get hasEvidence => _$this._hasEvidence;
  set hasEvidence(bool? hasEvidence) => _$this._hasEvidence = hasEvidence;

  String? _evidencePath;
  String? get evidencePath => _$this._evidencePath;
  set evidencePath(String? evidencePath) => _$this._evidencePath = evidencePath;

  bool? _confirmedByReview;
  bool? get confirmedByReview => _$this._confirmedByReview;
  set confirmedByReview(bool? confirmedByReview) =>
      _$this._confirmedByReview = confirmedByReview;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ReimbursementTimelineItemBuilder() {
    ReimbursementTimelineItem._defaults(this);
  }

  ReimbursementTimelineItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _state = $v.state;
      _amountCentavos = $v.amountCentavos;
      _method = $v.method;
      _reimbursedAt = $v.reimbursedAt;
      _buyerAcknowledgedAt = $v.buyerAcknowledgedAt;
      _hasEvidence = $v.hasEvidence;
      _evidencePath = $v.evidencePath;
      _confirmedByReview = $v.confirmedByReview;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReimbursementTimelineItem other) {
    _$v = other as _$ReimbursementTimelineItem;
  }

  @override
  void update(void Function(ReimbursementTimelineItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReimbursementTimelineItem build() => _build();

  _$ReimbursementTimelineItem _build() {
    final _$result = _$v ??
        _$ReimbursementTimelineItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ReimbursementTimelineItem', 'id'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'ReimbursementTimelineItem', 'state'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'ReimbursementTimelineItem', 'amountCentavos'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'ReimbursementTimelineItem', 'method'),
          reimbursedAt: reimbursedAt,
          buyerAcknowledgedAt: buyerAcknowledgedAt,
          hasEvidence: BuiltValueNullFieldError.checkNotNull(
              hasEvidence, r'ReimbursementTimelineItem', 'hasEvidence'),
          evidencePath: evidencePath,
          confirmedByReview: BuiltValueNullFieldError.checkNotNull(
              confirmedByReview,
              r'ReimbursementTimelineItem',
              'confirmedByReview'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'ReimbursementTimelineItem', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
