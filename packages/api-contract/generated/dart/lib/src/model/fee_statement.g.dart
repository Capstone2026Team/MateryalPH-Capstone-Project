// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_statement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FeeStatementStateEnum _$feeStatementStateEnum_DRAFT =
    const FeeStatementStateEnum._('DRAFT');
const FeeStatementStateEnum _$feeStatementStateEnum_ISSUED =
    const FeeStatementStateEnum._('ISSUED');
const FeeStatementStateEnum _$feeStatementStateEnum_PARTIALLY_PAID =
    const FeeStatementStateEnum._('PARTIALLY_PAID');
const FeeStatementStateEnum _$feeStatementStateEnum_PAID =
    const FeeStatementStateEnum._('PAID');
const FeeStatementStateEnum _$feeStatementStateEnum_VOIDED =
    const FeeStatementStateEnum._('VOIDED');

FeeStatementStateEnum _$feeStatementStateEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$feeStatementStateEnum_DRAFT;
    case 'ISSUED':
      return _$feeStatementStateEnum_ISSUED;
    case 'PARTIALLY_PAID':
      return _$feeStatementStateEnum_PARTIALLY_PAID;
    case 'PAID':
      return _$feeStatementStateEnum_PAID;
    case 'VOIDED':
      return _$feeStatementStateEnum_VOIDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FeeStatementStateEnum> _$feeStatementStateEnumValues =
    BuiltSet<FeeStatementStateEnum>(const <FeeStatementStateEnum>[
  _$feeStatementStateEnum_DRAFT,
  _$feeStatementStateEnum_ISSUED,
  _$feeStatementStateEnum_PARTIALLY_PAID,
  _$feeStatementStateEnum_PAID,
  _$feeStatementStateEnum_VOIDED,
]);

Serializer<FeeStatementStateEnum> _$feeStatementStateEnumSerializer =
    _$FeeStatementStateEnumSerializer();

class _$FeeStatementStateEnumSerializer
    implements PrimitiveSerializer<FeeStatementStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'ISSUED': 'ISSUED',
    'PARTIALLY_PAID': 'PARTIALLY_PAID',
    'PAID': 'PAID',
    'VOIDED': 'VOIDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'ISSUED': 'ISSUED',
    'PARTIALLY_PAID': 'PARTIALLY_PAID',
    'PAID': 'PAID',
    'VOIDED': 'VOIDED',
  };

  @override
  final Iterable<Type> types = const <Type>[FeeStatementStateEnum];
  @override
  final String wireName = 'FeeStatementStateEnum';

  @override
  Object serialize(Serializers serializers, FeeStatementStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FeeStatementStateEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FeeStatementStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FeeStatement extends FeeStatement {
  @override
  final String id;
  @override
  final String reference;
  @override
  final FeeStatementStateEnum state;
  @override
  final bool overdue;
  @override
  final String periodStart;
  @override
  final String periodEnd;
  @override
  final String issuedOn;
  @override
  final String dueOn;
  @override
  final int chargesCentavos;
  @override
  final int creditsCentavos;
  @override
  final int paidCentavos;
  @override
  final int outstandingCentavos;
  @override
  final int disputedHeldCentavos;
  @override
  final int lockVersion;
  @override
  final String sampleNotice;

  factory _$FeeStatement([void Function(FeeStatementBuilder)? updates]) =>
      (FeeStatementBuilder()..update(updates))._build();

  _$FeeStatement._(
      {required this.id,
      required this.reference,
      required this.state,
      required this.overdue,
      required this.periodStart,
      required this.periodEnd,
      required this.issuedOn,
      required this.dueOn,
      required this.chargesCentavos,
      required this.creditsCentavos,
      required this.paidCentavos,
      required this.outstandingCentavos,
      required this.disputedHeldCentavos,
      required this.lockVersion,
      required this.sampleNotice})
      : super._();
  @override
  FeeStatement rebuild(void Function(FeeStatementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeeStatementBuilder toBuilder() => FeeStatementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeeStatement &&
        id == other.id &&
        reference == other.reference &&
        state == other.state &&
        overdue == other.overdue &&
        periodStart == other.periodStart &&
        periodEnd == other.periodEnd &&
        issuedOn == other.issuedOn &&
        dueOn == other.dueOn &&
        chargesCentavos == other.chargesCentavos &&
        creditsCentavos == other.creditsCentavos &&
        paidCentavos == other.paidCentavos &&
        outstandingCentavos == other.outstandingCentavos &&
        disputedHeldCentavos == other.disputedHeldCentavos &&
        lockVersion == other.lockVersion &&
        sampleNotice == other.sampleNotice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, overdue.hashCode);
    _$hash = $jc(_$hash, periodStart.hashCode);
    _$hash = $jc(_$hash, periodEnd.hashCode);
    _$hash = $jc(_$hash, issuedOn.hashCode);
    _$hash = $jc(_$hash, dueOn.hashCode);
    _$hash = $jc(_$hash, chargesCentavos.hashCode);
    _$hash = $jc(_$hash, creditsCentavos.hashCode);
    _$hash = $jc(_$hash, paidCentavos.hashCode);
    _$hash = $jc(_$hash, outstandingCentavos.hashCode);
    _$hash = $jc(_$hash, disputedHeldCentavos.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, sampleNotice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FeeStatement')
          ..add('id', id)
          ..add('reference', reference)
          ..add('state', state)
          ..add('overdue', overdue)
          ..add('periodStart', periodStart)
          ..add('periodEnd', periodEnd)
          ..add('issuedOn', issuedOn)
          ..add('dueOn', dueOn)
          ..add('chargesCentavos', chargesCentavos)
          ..add('creditsCentavos', creditsCentavos)
          ..add('paidCentavos', paidCentavos)
          ..add('outstandingCentavos', outstandingCentavos)
          ..add('disputedHeldCentavos', disputedHeldCentavos)
          ..add('lockVersion', lockVersion)
          ..add('sampleNotice', sampleNotice))
        .toString();
  }
}

class FeeStatementBuilder
    implements Builder<FeeStatement, FeeStatementBuilder> {
  _$FeeStatement? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  FeeStatementStateEnum? _state;
  FeeStatementStateEnum? get state => _$this._state;
  set state(FeeStatementStateEnum? state) => _$this._state = state;

  bool? _overdue;
  bool? get overdue => _$this._overdue;
  set overdue(bool? overdue) => _$this._overdue = overdue;

  String? _periodStart;
  String? get periodStart => _$this._periodStart;
  set periodStart(String? periodStart) => _$this._periodStart = periodStart;

  String? _periodEnd;
  String? get periodEnd => _$this._periodEnd;
  set periodEnd(String? periodEnd) => _$this._periodEnd = periodEnd;

  String? _issuedOn;
  String? get issuedOn => _$this._issuedOn;
  set issuedOn(String? issuedOn) => _$this._issuedOn = issuedOn;

  String? _dueOn;
  String? get dueOn => _$this._dueOn;
  set dueOn(String? dueOn) => _$this._dueOn = dueOn;

  int? _chargesCentavos;
  int? get chargesCentavos => _$this._chargesCentavos;
  set chargesCentavos(int? chargesCentavos) =>
      _$this._chargesCentavos = chargesCentavos;

  int? _creditsCentavos;
  int? get creditsCentavos => _$this._creditsCentavos;
  set creditsCentavos(int? creditsCentavos) =>
      _$this._creditsCentavos = creditsCentavos;

  int? _paidCentavos;
  int? get paidCentavos => _$this._paidCentavos;
  set paidCentavos(int? paidCentavos) => _$this._paidCentavos = paidCentavos;

  int? _outstandingCentavos;
  int? get outstandingCentavos => _$this._outstandingCentavos;
  set outstandingCentavos(int? outstandingCentavos) =>
      _$this._outstandingCentavos = outstandingCentavos;

  int? _disputedHeldCentavos;
  int? get disputedHeldCentavos => _$this._disputedHeldCentavos;
  set disputedHeldCentavos(int? disputedHeldCentavos) =>
      _$this._disputedHeldCentavos = disputedHeldCentavos;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _sampleNotice;
  String? get sampleNotice => _$this._sampleNotice;
  set sampleNotice(String? sampleNotice) => _$this._sampleNotice = sampleNotice;

  FeeStatementBuilder() {
    FeeStatement._defaults(this);
  }

  FeeStatementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _state = $v.state;
      _overdue = $v.overdue;
      _periodStart = $v.periodStart;
      _periodEnd = $v.periodEnd;
      _issuedOn = $v.issuedOn;
      _dueOn = $v.dueOn;
      _chargesCentavos = $v.chargesCentavos;
      _creditsCentavos = $v.creditsCentavos;
      _paidCentavos = $v.paidCentavos;
      _outstandingCentavos = $v.outstandingCentavos;
      _disputedHeldCentavos = $v.disputedHeldCentavos;
      _lockVersion = $v.lockVersion;
      _sampleNotice = $v.sampleNotice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeeStatement other) {
    _$v = other as _$FeeStatement;
  }

  @override
  void update(void Function(FeeStatementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeeStatement build() => _build();

  _$FeeStatement _build() {
    final _$result = _$v ??
        _$FeeStatement._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FeeStatement', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'FeeStatement', 'reference'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'FeeStatement', 'state'),
          overdue: BuiltValueNullFieldError.checkNotNull(
              overdue, r'FeeStatement', 'overdue'),
          periodStart: BuiltValueNullFieldError.checkNotNull(
              periodStart, r'FeeStatement', 'periodStart'),
          periodEnd: BuiltValueNullFieldError.checkNotNull(
              periodEnd, r'FeeStatement', 'periodEnd'),
          issuedOn: BuiltValueNullFieldError.checkNotNull(
              issuedOn, r'FeeStatement', 'issuedOn'),
          dueOn: BuiltValueNullFieldError.checkNotNull(
              dueOn, r'FeeStatement', 'dueOn'),
          chargesCentavos: BuiltValueNullFieldError.checkNotNull(
              chargesCentavos, r'FeeStatement', 'chargesCentavos'),
          creditsCentavos: BuiltValueNullFieldError.checkNotNull(
              creditsCentavos, r'FeeStatement', 'creditsCentavos'),
          paidCentavos: BuiltValueNullFieldError.checkNotNull(
              paidCentavos, r'FeeStatement', 'paidCentavos'),
          outstandingCentavos: BuiltValueNullFieldError.checkNotNull(
              outstandingCentavos, r'FeeStatement', 'outstandingCentavos'),
          disputedHeldCentavos: BuiltValueNullFieldError.checkNotNull(
              disputedHeldCentavos, r'FeeStatement', 'disputedHeldCentavos'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'FeeStatement', 'lockVersion'),
          sampleNotice: BuiltValueNullFieldError.checkNotNull(
              sampleNotice, r'FeeStatement', 'sampleNotice'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
