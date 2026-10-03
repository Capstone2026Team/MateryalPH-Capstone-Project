// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_statement_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeeStatementDetail extends FeeStatementDetail {
  @override
  final String id;
  @override
  final String reference;
  @override
  final String state;
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
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> lines;
  @override
  final BuiltList<PaymentAttempt> payments;
  @override
  final BuiltList<PaymentChannelOption> channels;

  factory _$FeeStatementDetail(
          [void Function(FeeStatementDetailBuilder)? updates]) =>
      (FeeStatementDetailBuilder()..update(updates))._build();

  _$FeeStatementDetail._(
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
      required this.sampleNotice,
      required this.lines,
      required this.payments,
      required this.channels})
      : super._();
  @override
  FeeStatementDetail rebuild(
          void Function(FeeStatementDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeeStatementDetailBuilder toBuilder() =>
      FeeStatementDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeeStatementDetail &&
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
        sampleNotice == other.sampleNotice &&
        lines == other.lines &&
        payments == other.payments &&
        channels == other.channels;
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
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jc(_$hash, channels.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FeeStatementDetail')
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
          ..add('sampleNotice', sampleNotice)
          ..add('lines', lines)
          ..add('payments', payments)
          ..add('channels', channels))
        .toString();
  }
}

class FeeStatementDetailBuilder
    implements Builder<FeeStatementDetail, FeeStatementDetailBuilder> {
  _$FeeStatementDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

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

  ListBuilder<BuiltMap<String, JsonObject?>>? _lines;
  ListBuilder<BuiltMap<String, JsonObject?>> get lines =>
      _$this._lines ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set lines(ListBuilder<BuiltMap<String, JsonObject?>>? lines) =>
      _$this._lines = lines;

  ListBuilder<PaymentAttempt>? _payments;
  ListBuilder<PaymentAttempt> get payments =>
      _$this._payments ??= ListBuilder<PaymentAttempt>();
  set payments(ListBuilder<PaymentAttempt>? payments) =>
      _$this._payments = payments;

  ListBuilder<PaymentChannelOption>? _channels;
  ListBuilder<PaymentChannelOption> get channels =>
      _$this._channels ??= ListBuilder<PaymentChannelOption>();
  set channels(ListBuilder<PaymentChannelOption>? channels) =>
      _$this._channels = channels;

  FeeStatementDetailBuilder() {
    FeeStatementDetail._defaults(this);
  }

  FeeStatementDetailBuilder get _$this {
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
      _lines = $v.lines.toBuilder();
      _payments = $v.payments.toBuilder();
      _channels = $v.channels.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeeStatementDetail other) {
    _$v = other as _$FeeStatementDetail;
  }

  @override
  void update(void Function(FeeStatementDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeeStatementDetail build() => _build();

  _$FeeStatementDetail _build() {
    _$FeeStatementDetail _$result;
    try {
      _$result = _$v ??
          _$FeeStatementDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'FeeStatementDetail', 'id'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, r'FeeStatementDetail', 'reference'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'FeeStatementDetail', 'state'),
            overdue: BuiltValueNullFieldError.checkNotNull(
                overdue, r'FeeStatementDetail', 'overdue'),
            periodStart: BuiltValueNullFieldError.checkNotNull(
                periodStart, r'FeeStatementDetail', 'periodStart'),
            periodEnd: BuiltValueNullFieldError.checkNotNull(
                periodEnd, r'FeeStatementDetail', 'periodEnd'),
            issuedOn: BuiltValueNullFieldError.checkNotNull(
                issuedOn, r'FeeStatementDetail', 'issuedOn'),
            dueOn: BuiltValueNullFieldError.checkNotNull(
                dueOn, r'FeeStatementDetail', 'dueOn'),
            chargesCentavos: BuiltValueNullFieldError.checkNotNull(
                chargesCentavos, r'FeeStatementDetail', 'chargesCentavos'),
            creditsCentavos: BuiltValueNullFieldError.checkNotNull(
                creditsCentavos, r'FeeStatementDetail', 'creditsCentavos'),
            paidCentavos: BuiltValueNullFieldError.checkNotNull(
                paidCentavos, r'FeeStatementDetail', 'paidCentavos'),
            outstandingCentavos: BuiltValueNullFieldError.checkNotNull(
                outstandingCentavos,
                r'FeeStatementDetail',
                'outstandingCentavos'),
            disputedHeldCentavos: BuiltValueNullFieldError.checkNotNull(
                disputedHeldCentavos,
                r'FeeStatementDetail',
                'disputedHeldCentavos'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'FeeStatementDetail', 'lockVersion'),
            sampleNotice: BuiltValueNullFieldError.checkNotNull(
                sampleNotice, r'FeeStatementDetail', 'sampleNotice'),
            lines: lines.build(),
            payments: payments.build(),
            channels: channels.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'payments';
        payments.build();
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FeeStatementDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
