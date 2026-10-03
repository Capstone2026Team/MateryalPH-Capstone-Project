// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_line_allocation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NrpcLineAllocation extends NrpcLineAllocation {
  @override
  final String orderLineId;
  @override
  final int principalCentavos;

  factory _$NrpcLineAllocation(
          [void Function(NrpcLineAllocationBuilder)? updates]) =>
      (NrpcLineAllocationBuilder()..update(updates))._build();

  _$NrpcLineAllocation._(
      {required this.orderLineId, required this.principalCentavos})
      : super._();
  @override
  NrpcLineAllocation rebuild(
          void Function(NrpcLineAllocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcLineAllocationBuilder toBuilder() =>
      NrpcLineAllocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcLineAllocation &&
        orderLineId == other.orderLineId &&
        principalCentavos == other.principalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, principalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcLineAllocation')
          ..add('orderLineId', orderLineId)
          ..add('principalCentavos', principalCentavos))
        .toString();
  }
}

class NrpcLineAllocationBuilder
    implements Builder<NrpcLineAllocation, NrpcLineAllocationBuilder> {
  _$NrpcLineAllocation? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  int? _principalCentavos;
  int? get principalCentavos => _$this._principalCentavos;
  set principalCentavos(int? principalCentavos) =>
      _$this._principalCentavos = principalCentavos;

  NrpcLineAllocationBuilder() {
    NrpcLineAllocation._defaults(this);
  }

  NrpcLineAllocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _principalCentavos = $v.principalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcLineAllocation other) {
    _$v = other as _$NrpcLineAllocation;
  }

  @override
  void update(void Function(NrpcLineAllocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcLineAllocation build() => _build();

  _$NrpcLineAllocation _build() {
    final _$result = _$v ??
        _$NrpcLineAllocation._(
          orderLineId: BuiltValueNullFieldError.checkNotNull(
              orderLineId, r'NrpcLineAllocation', 'orderLineId'),
          principalCentavos: BuiltValueNullFieldError.checkNotNull(
              principalCentavos, r'NrpcLineAllocation', 'principalCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
