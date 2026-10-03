// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_payment_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PhysicalPaymentSummary extends PhysicalPaymentSummary {
  @override
  final bool applicable;
  @override
  final String method;
  @override
  final String state;
  @override
  final int? remainingCentavos;
  @override
  final bool onlineBalanceApproved;
  @override
  final BuiltList<PhysicalPaymentRecord> records;
  @override
  final String notice;

  factory _$PhysicalPaymentSummary(
          [void Function(PhysicalPaymentSummaryBuilder)? updates]) =>
      (PhysicalPaymentSummaryBuilder()..update(updates))._build();

  _$PhysicalPaymentSummary._(
      {required this.applicable,
      required this.method,
      required this.state,
      this.remainingCentavos,
      required this.onlineBalanceApproved,
      required this.records,
      required this.notice})
      : super._();
  @override
  PhysicalPaymentSummary rebuild(
          void Function(PhysicalPaymentSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhysicalPaymentSummaryBuilder toBuilder() =>
      PhysicalPaymentSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhysicalPaymentSummary &&
        applicable == other.applicable &&
        method == other.method &&
        state == other.state &&
        remainingCentavos == other.remainingCentavos &&
        onlineBalanceApproved == other.onlineBalanceApproved &&
        records == other.records &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, applicable.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, remainingCentavos.hashCode);
    _$hash = $jc(_$hash, onlineBalanceApproved.hashCode);
    _$hash = $jc(_$hash, records.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhysicalPaymentSummary')
          ..add('applicable', applicable)
          ..add('method', method)
          ..add('state', state)
          ..add('remainingCentavos', remainingCentavos)
          ..add('onlineBalanceApproved', onlineBalanceApproved)
          ..add('records', records)
          ..add('notice', notice))
        .toString();
  }
}

class PhysicalPaymentSummaryBuilder
    implements Builder<PhysicalPaymentSummary, PhysicalPaymentSummaryBuilder> {
  _$PhysicalPaymentSummary? _$v;

  bool? _applicable;
  bool? get applicable => _$this._applicable;
  set applicable(bool? applicable) => _$this._applicable = applicable;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  int? _remainingCentavos;
  int? get remainingCentavos => _$this._remainingCentavos;
  set remainingCentavos(int? remainingCentavos) =>
      _$this._remainingCentavos = remainingCentavos;

  bool? _onlineBalanceApproved;
  bool? get onlineBalanceApproved => _$this._onlineBalanceApproved;
  set onlineBalanceApproved(bool? onlineBalanceApproved) =>
      _$this._onlineBalanceApproved = onlineBalanceApproved;

  ListBuilder<PhysicalPaymentRecord>? _records;
  ListBuilder<PhysicalPaymentRecord> get records =>
      _$this._records ??= ListBuilder<PhysicalPaymentRecord>();
  set records(ListBuilder<PhysicalPaymentRecord>? records) =>
      _$this._records = records;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  PhysicalPaymentSummaryBuilder() {
    PhysicalPaymentSummary._defaults(this);
  }

  PhysicalPaymentSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _applicable = $v.applicable;
      _method = $v.method;
      _state = $v.state;
      _remainingCentavos = $v.remainingCentavos;
      _onlineBalanceApproved = $v.onlineBalanceApproved;
      _records = $v.records.toBuilder();
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhysicalPaymentSummary other) {
    _$v = other as _$PhysicalPaymentSummary;
  }

  @override
  void update(void Function(PhysicalPaymentSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhysicalPaymentSummary build() => _build();

  _$PhysicalPaymentSummary _build() {
    _$PhysicalPaymentSummary _$result;
    try {
      _$result = _$v ??
          _$PhysicalPaymentSummary._(
            applicable: BuiltValueNullFieldError.checkNotNull(
                applicable, r'PhysicalPaymentSummary', 'applicable'),
            method: BuiltValueNullFieldError.checkNotNull(
                method, r'PhysicalPaymentSummary', 'method'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'PhysicalPaymentSummary', 'state'),
            remainingCentavos: remainingCentavos,
            onlineBalanceApproved: BuiltValueNullFieldError.checkNotNull(
                onlineBalanceApproved,
                r'PhysicalPaymentSummary',
                'onlineBalanceApproved'),
            records: records.build(),
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'PhysicalPaymentSummary', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'records';
        records.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PhysicalPaymentSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
