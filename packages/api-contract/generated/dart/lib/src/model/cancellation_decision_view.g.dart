// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_decision_view.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CancellationDecisionViewCauseEnum
    _$cancellationDecisionViewCauseEnum_BUYER =
    const CancellationDecisionViewCauseEnum._('BUYER');
const CancellationDecisionViewCauseEnum
    _$cancellationDecisionViewCauseEnum_VENDOR =
    const CancellationDecisionViewCauseEnum._('VENDOR');

CancellationDecisionViewCauseEnum _$cancellationDecisionViewCauseEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$cancellationDecisionViewCauseEnum_BUYER;
    case 'VENDOR':
      return _$cancellationDecisionViewCauseEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CancellationDecisionViewCauseEnum>
    _$cancellationDecisionViewCauseEnumValues = BuiltSet<
        CancellationDecisionViewCauseEnum>(const <CancellationDecisionViewCauseEnum>[
  _$cancellationDecisionViewCauseEnum_BUYER,
  _$cancellationDecisionViewCauseEnum_VENDOR,
]);

const CancellationDecisionViewDecidedByEnum
    _$cancellationDecisionViewDecidedByEnum_BUYER =
    const CancellationDecisionViewDecidedByEnum._('BUYER');
const CancellationDecisionViewDecidedByEnum
    _$cancellationDecisionViewDecidedByEnum_VENDOR =
    const CancellationDecisionViewDecidedByEnum._('VENDOR');
const CancellationDecisionViewDecidedByEnum
    _$cancellationDecisionViewDecidedByEnum_SYSTEM =
    const CancellationDecisionViewDecidedByEnum._('SYSTEM');

CancellationDecisionViewDecidedByEnum
    _$cancellationDecisionViewDecidedByEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$cancellationDecisionViewDecidedByEnum_BUYER;
    case 'VENDOR':
      return _$cancellationDecisionViewDecidedByEnum_VENDOR;
    case 'SYSTEM':
      return _$cancellationDecisionViewDecidedByEnum_SYSTEM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CancellationDecisionViewDecidedByEnum>
    _$cancellationDecisionViewDecidedByEnumValues = BuiltSet<
        CancellationDecisionViewDecidedByEnum>(const <CancellationDecisionViewDecidedByEnum>[
  _$cancellationDecisionViewDecidedByEnum_BUYER,
  _$cancellationDecisionViewDecidedByEnum_VENDOR,
  _$cancellationDecisionViewDecidedByEnum_SYSTEM,
]);

Serializer<CancellationDecisionViewCauseEnum>
    _$cancellationDecisionViewCauseEnumSerializer =
    _$CancellationDecisionViewCauseEnumSerializer();
Serializer<CancellationDecisionViewDecidedByEnum>
    _$cancellationDecisionViewDecidedByEnumSerializer =
    _$CancellationDecisionViewDecidedByEnumSerializer();

class _$CancellationDecisionViewCauseEnumSerializer
    implements PrimitiveSerializer<CancellationDecisionViewCauseEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[CancellationDecisionViewCauseEnum];
  @override
  final String wireName = 'CancellationDecisionViewCauseEnum';

  @override
  Object serialize(
          Serializers serializers, CancellationDecisionViewCauseEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CancellationDecisionViewCauseEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CancellationDecisionViewCauseEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CancellationDecisionViewDecidedByEnumSerializer
    implements PrimitiveSerializer<CancellationDecisionViewDecidedByEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'SYSTEM': 'SYSTEM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'SYSTEM': 'SYSTEM',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CancellationDecisionViewDecidedByEnum
  ];
  @override
  final String wireName = 'CancellationDecisionViewDecidedByEnum';

  @override
  Object serialize(
          Serializers serializers, CancellationDecisionViewDecidedByEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CancellationDecisionViewDecidedByEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CancellationDecisionViewDecidedByEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CancellationDecisionView extends CancellationDecisionView {
  @override
  final CancellationDecisionViewCauseEnum cause;
  @override
  final CancellationDecisionViewDecidedByEnum decidedBy;
  @override
  final String decisionCode;
  @override
  final String? reasonCode;
  @override
  final String? reason;
  @override
  final int nrpcRetainedCentavos;
  @override
  final int refundTotalCentavos;
  @override
  final int cashReimbursementCentavos;
  @override
  final int releasedUnpaidCentavos;
  @override
  final String orderStateBefore;
  @override
  final DateTime? decidedAt;
  @override
  final bool nrpcEvidenceOnFile;
  @override
  final String? nrpcEvidencePath;

  factory _$CancellationDecisionView(
          [void Function(CancellationDecisionViewBuilder)? updates]) =>
      (CancellationDecisionViewBuilder()..update(updates))._build();

  _$CancellationDecisionView._(
      {required this.cause,
      required this.decidedBy,
      required this.decisionCode,
      this.reasonCode,
      this.reason,
      required this.nrpcRetainedCentavos,
      required this.refundTotalCentavos,
      required this.cashReimbursementCentavos,
      required this.releasedUnpaidCentavos,
      required this.orderStateBefore,
      this.decidedAt,
      required this.nrpcEvidenceOnFile,
      this.nrpcEvidencePath})
      : super._();
  @override
  CancellationDecisionView rebuild(
          void Function(CancellationDecisionViewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationDecisionViewBuilder toBuilder() =>
      CancellationDecisionViewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationDecisionView &&
        cause == other.cause &&
        decidedBy == other.decidedBy &&
        decisionCode == other.decisionCode &&
        reasonCode == other.reasonCode &&
        reason == other.reason &&
        nrpcRetainedCentavos == other.nrpcRetainedCentavos &&
        refundTotalCentavos == other.refundTotalCentavos &&
        cashReimbursementCentavos == other.cashReimbursementCentavos &&
        releasedUnpaidCentavos == other.releasedUnpaidCentavos &&
        orderStateBefore == other.orderStateBefore &&
        decidedAt == other.decidedAt &&
        nrpcEvidenceOnFile == other.nrpcEvidenceOnFile &&
        nrpcEvidencePath == other.nrpcEvidencePath;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cause.hashCode);
    _$hash = $jc(_$hash, decidedBy.hashCode);
    _$hash = $jc(_$hash, decisionCode.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, nrpcRetainedCentavos.hashCode);
    _$hash = $jc(_$hash, refundTotalCentavos.hashCode);
    _$hash = $jc(_$hash, cashReimbursementCentavos.hashCode);
    _$hash = $jc(_$hash, releasedUnpaidCentavos.hashCode);
    _$hash = $jc(_$hash, orderStateBefore.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, nrpcEvidenceOnFile.hashCode);
    _$hash = $jc(_$hash, nrpcEvidencePath.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationDecisionView')
          ..add('cause', cause)
          ..add('decidedBy', decidedBy)
          ..add('decisionCode', decisionCode)
          ..add('reasonCode', reasonCode)
          ..add('reason', reason)
          ..add('nrpcRetainedCentavos', nrpcRetainedCentavos)
          ..add('refundTotalCentavos', refundTotalCentavos)
          ..add('cashReimbursementCentavos', cashReimbursementCentavos)
          ..add('releasedUnpaidCentavos', releasedUnpaidCentavos)
          ..add('orderStateBefore', orderStateBefore)
          ..add('decidedAt', decidedAt)
          ..add('nrpcEvidenceOnFile', nrpcEvidenceOnFile)
          ..add('nrpcEvidencePath', nrpcEvidencePath))
        .toString();
  }
}

class CancellationDecisionViewBuilder
    implements
        Builder<CancellationDecisionView, CancellationDecisionViewBuilder> {
  _$CancellationDecisionView? _$v;

  CancellationDecisionViewCauseEnum? _cause;
  CancellationDecisionViewCauseEnum? get cause => _$this._cause;
  set cause(CancellationDecisionViewCauseEnum? cause) => _$this._cause = cause;

  CancellationDecisionViewDecidedByEnum? _decidedBy;
  CancellationDecisionViewDecidedByEnum? get decidedBy => _$this._decidedBy;
  set decidedBy(CancellationDecisionViewDecidedByEnum? decidedBy) =>
      _$this._decidedBy = decidedBy;

  String? _decisionCode;
  String? get decisionCode => _$this._decisionCode;
  set decisionCode(String? decisionCode) => _$this._decisionCode = decisionCode;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _nrpcRetainedCentavos;
  int? get nrpcRetainedCentavos => _$this._nrpcRetainedCentavos;
  set nrpcRetainedCentavos(int? nrpcRetainedCentavos) =>
      _$this._nrpcRetainedCentavos = nrpcRetainedCentavos;

  int? _refundTotalCentavos;
  int? get refundTotalCentavos => _$this._refundTotalCentavos;
  set refundTotalCentavos(int? refundTotalCentavos) =>
      _$this._refundTotalCentavos = refundTotalCentavos;

  int? _cashReimbursementCentavos;
  int? get cashReimbursementCentavos => _$this._cashReimbursementCentavos;
  set cashReimbursementCentavos(int? cashReimbursementCentavos) =>
      _$this._cashReimbursementCentavos = cashReimbursementCentavos;

  int? _releasedUnpaidCentavos;
  int? get releasedUnpaidCentavos => _$this._releasedUnpaidCentavos;
  set releasedUnpaidCentavos(int? releasedUnpaidCentavos) =>
      _$this._releasedUnpaidCentavos = releasedUnpaidCentavos;

  String? _orderStateBefore;
  String? get orderStateBefore => _$this._orderStateBefore;
  set orderStateBefore(String? orderStateBefore) =>
      _$this._orderStateBefore = orderStateBefore;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  bool? _nrpcEvidenceOnFile;
  bool? get nrpcEvidenceOnFile => _$this._nrpcEvidenceOnFile;
  set nrpcEvidenceOnFile(bool? nrpcEvidenceOnFile) =>
      _$this._nrpcEvidenceOnFile = nrpcEvidenceOnFile;

  String? _nrpcEvidencePath;
  String? get nrpcEvidencePath => _$this._nrpcEvidencePath;
  set nrpcEvidencePath(String? nrpcEvidencePath) =>
      _$this._nrpcEvidencePath = nrpcEvidencePath;

  CancellationDecisionViewBuilder() {
    CancellationDecisionView._defaults(this);
  }

  CancellationDecisionViewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cause = $v.cause;
      _decidedBy = $v.decidedBy;
      _decisionCode = $v.decisionCode;
      _reasonCode = $v.reasonCode;
      _reason = $v.reason;
      _nrpcRetainedCentavos = $v.nrpcRetainedCentavos;
      _refundTotalCentavos = $v.refundTotalCentavos;
      _cashReimbursementCentavos = $v.cashReimbursementCentavos;
      _releasedUnpaidCentavos = $v.releasedUnpaidCentavos;
      _orderStateBefore = $v.orderStateBefore;
      _decidedAt = $v.decidedAt;
      _nrpcEvidenceOnFile = $v.nrpcEvidenceOnFile;
      _nrpcEvidencePath = $v.nrpcEvidencePath;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationDecisionView other) {
    _$v = other as _$CancellationDecisionView;
  }

  @override
  void update(void Function(CancellationDecisionViewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationDecisionView build() => _build();

  _$CancellationDecisionView _build() {
    final _$result = _$v ??
        _$CancellationDecisionView._(
          cause: BuiltValueNullFieldError.checkNotNull(
              cause, r'CancellationDecisionView', 'cause'),
          decidedBy: BuiltValueNullFieldError.checkNotNull(
              decidedBy, r'CancellationDecisionView', 'decidedBy'),
          decisionCode: BuiltValueNullFieldError.checkNotNull(
              decisionCode, r'CancellationDecisionView', 'decisionCode'),
          reasonCode: reasonCode,
          reason: reason,
          nrpcRetainedCentavos: BuiltValueNullFieldError.checkNotNull(
              nrpcRetainedCentavos,
              r'CancellationDecisionView',
              'nrpcRetainedCentavos'),
          refundTotalCentavos: BuiltValueNullFieldError.checkNotNull(
              refundTotalCentavos,
              r'CancellationDecisionView',
              'refundTotalCentavos'),
          cashReimbursementCentavos: BuiltValueNullFieldError.checkNotNull(
              cashReimbursementCentavos,
              r'CancellationDecisionView',
              'cashReimbursementCentavos'),
          releasedUnpaidCentavos: BuiltValueNullFieldError.checkNotNull(
              releasedUnpaidCentavos,
              r'CancellationDecisionView',
              'releasedUnpaidCentavos'),
          orderStateBefore: BuiltValueNullFieldError.checkNotNull(
              orderStateBefore,
              r'CancellationDecisionView',
              'orderStateBefore'),
          decidedAt: decidedAt,
          nrpcEvidenceOnFile: BuiltValueNullFieldError.checkNotNull(
              nrpcEvidenceOnFile,
              r'CancellationDecisionView',
              'nrpcEvidenceOnFile'),
          nrpcEvidencePath: nrpcEvidencePath,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
