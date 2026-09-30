// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_proposal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NrpcProposal extends NrpcProposal {
  @override
  final int amountCentavos;
  @override
  final String reason;
  @override
  final BuiltList<NrpcLineAllocation> lines;

  factory _$NrpcProposal([void Function(NrpcProposalBuilder)? updates]) =>
      (NrpcProposalBuilder()..update(updates))._build();

  _$NrpcProposal._(
      {required this.amountCentavos, required this.reason, required this.lines})
      : super._();
  @override
  NrpcProposal rebuild(void Function(NrpcProposalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcProposalBuilder toBuilder() => NrpcProposalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcProposal &&
        amountCentavos == other.amountCentavos &&
        reason == other.reason &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcProposal')
          ..add('amountCentavos', amountCentavos)
          ..add('reason', reason)
          ..add('lines', lines))
        .toString();
  }
}

class NrpcProposalBuilder
    implements Builder<NrpcProposal, NrpcProposalBuilder> {
  _$NrpcProposal? _$v;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ListBuilder<NrpcLineAllocation>? _lines;
  ListBuilder<NrpcLineAllocation> get lines =>
      _$this._lines ??= ListBuilder<NrpcLineAllocation>();
  set lines(ListBuilder<NrpcLineAllocation>? lines) => _$this._lines = lines;

  NrpcProposalBuilder() {
    NrpcProposal._defaults(this);
  }

  NrpcProposalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amountCentavos = $v.amountCentavos;
      _reason = $v.reason;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcProposal other) {
    _$v = other as _$NrpcProposal;
  }

  @override
  void update(void Function(NrpcProposalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcProposal build() => _build();

  _$NrpcProposal _build() {
    _$NrpcProposal _$result;
    try {
      _$result = _$v ??
          _$NrpcProposal._(
            amountCentavos: BuiltValueNullFieldError.checkNotNull(
                amountCentavos, r'NrpcProposal', 'amountCentavos'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'NrpcProposal', 'reason'),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NrpcProposal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
