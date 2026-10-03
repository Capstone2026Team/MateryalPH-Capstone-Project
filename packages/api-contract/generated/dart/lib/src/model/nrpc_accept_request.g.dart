// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_accept_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NrpcAcceptRequestAcknowledgedEnum
    _$nrpcAcceptRequestAcknowledgedEnum_true_ =
    const NrpcAcceptRequestAcknowledgedEnum._('true_');

NrpcAcceptRequestAcknowledgedEnum _$nrpcAcceptRequestAcknowledgedEnumValueOf(
    String name) {
  switch (name) {
    case 'true_':
      return _$nrpcAcceptRequestAcknowledgedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NrpcAcceptRequestAcknowledgedEnum>
    _$nrpcAcceptRequestAcknowledgedEnumValues = BuiltSet<
        NrpcAcceptRequestAcknowledgedEnum>(const <NrpcAcceptRequestAcknowledgedEnum>[
  _$nrpcAcceptRequestAcknowledgedEnum_true_,
]);

Serializer<NrpcAcceptRequestAcknowledgedEnum>
    _$nrpcAcceptRequestAcknowledgedEnumSerializer =
    _$NrpcAcceptRequestAcknowledgedEnumSerializer();

class _$NrpcAcceptRequestAcknowledgedEnumSerializer
    implements PrimitiveSerializer<NrpcAcceptRequestAcknowledgedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[NrpcAcceptRequestAcknowledgedEnum];
  @override
  final String wireName = 'NrpcAcceptRequestAcknowledgedEnum';

  @override
  Object serialize(
          Serializers serializers, NrpcAcceptRequestAcknowledgedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NrpcAcceptRequestAcknowledgedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NrpcAcceptRequestAcknowledgedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NrpcAcceptRequest extends NrpcAcceptRequest {
  @override
  final String? budgetOverrideReason;
  @override
  final int snapshotVersion;
  @override
  final String nrpcId;
  @override
  final String termsVersionId;
  @override
  final NrpcAcceptRequestAcknowledgedEnum acknowledged;

  factory _$NrpcAcceptRequest(
          [void Function(NrpcAcceptRequestBuilder)? updates]) =>
      (NrpcAcceptRequestBuilder()..update(updates))._build();

  _$NrpcAcceptRequest._(
      {this.budgetOverrideReason,
      required this.snapshotVersion,
      required this.nrpcId,
      required this.termsVersionId,
      required this.acknowledged})
      : super._();
  @override
  NrpcAcceptRequest rebuild(void Function(NrpcAcceptRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcAcceptRequestBuilder toBuilder() =>
      NrpcAcceptRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcAcceptRequest &&
        budgetOverrideReason == other.budgetOverrideReason &&
        snapshotVersion == other.snapshotVersion &&
        nrpcId == other.nrpcId &&
        termsVersionId == other.termsVersionId &&
        acknowledged == other.acknowledged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, nrpcId.hashCode);
    _$hash = $jc(_$hash, termsVersionId.hashCode);
    _$hash = $jc(_$hash, acknowledged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcAcceptRequest')
          ..add('budgetOverrideReason', budgetOverrideReason)
          ..add('snapshotVersion', snapshotVersion)
          ..add('nrpcId', nrpcId)
          ..add('termsVersionId', termsVersionId)
          ..add('acknowledged', acknowledged))
        .toString();
  }
}

class NrpcAcceptRequestBuilder
    implements Builder<NrpcAcceptRequest, NrpcAcceptRequestBuilder> {
  _$NrpcAcceptRequest? _$v;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  int? _snapshotVersion;
  int? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(int? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  String? _nrpcId;
  String? get nrpcId => _$this._nrpcId;
  set nrpcId(String? nrpcId) => _$this._nrpcId = nrpcId;

  String? _termsVersionId;
  String? get termsVersionId => _$this._termsVersionId;
  set termsVersionId(String? termsVersionId) =>
      _$this._termsVersionId = termsVersionId;

  NrpcAcceptRequestAcknowledgedEnum? _acknowledged;
  NrpcAcceptRequestAcknowledgedEnum? get acknowledged => _$this._acknowledged;
  set acknowledged(NrpcAcceptRequestAcknowledgedEnum? acknowledged) =>
      _$this._acknowledged = acknowledged;

  NrpcAcceptRequestBuilder() {
    NrpcAcceptRequest._defaults(this);
  }

  NrpcAcceptRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _budgetOverrideReason = $v.budgetOverrideReason;
      _snapshotVersion = $v.snapshotVersion;
      _nrpcId = $v.nrpcId;
      _termsVersionId = $v.termsVersionId;
      _acknowledged = $v.acknowledged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcAcceptRequest other) {
    _$v = other as _$NrpcAcceptRequest;
  }

  @override
  void update(void Function(NrpcAcceptRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcAcceptRequest build() => _build();

  _$NrpcAcceptRequest _build() {
    final _$result = _$v ??
        _$NrpcAcceptRequest._(
          budgetOverrideReason: budgetOverrideReason,
          snapshotVersion: BuiltValueNullFieldError.checkNotNull(
              snapshotVersion, r'NrpcAcceptRequest', 'snapshotVersion'),
          nrpcId: BuiltValueNullFieldError.checkNotNull(
              nrpcId, r'NrpcAcceptRequest', 'nrpcId'),
          termsVersionId: BuiltValueNullFieldError.checkNotNull(
              termsVersionId, r'NrpcAcceptRequest', 'termsVersionId'),
          acknowledged: BuiltValueNullFieldError.checkNotNull(
              acknowledged, r'NrpcAcceptRequest', 'acknowledged'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
