// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_flag.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NrpcFlagReviewStateEnum _$nrpcFlagReviewStateEnum_PENDING_ADMIN_REVIEW =
    const NrpcFlagReviewStateEnum._('PENDING_ADMIN_REVIEW');

NrpcFlagReviewStateEnum _$nrpcFlagReviewStateEnumValueOf(String name) {
  switch (name) {
    case 'PENDING_ADMIN_REVIEW':
      return _$nrpcFlagReviewStateEnum_PENDING_ADMIN_REVIEW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NrpcFlagReviewStateEnum> _$nrpcFlagReviewStateEnumValues =
    BuiltSet<NrpcFlagReviewStateEnum>(const <NrpcFlagReviewStateEnum>[
  _$nrpcFlagReviewStateEnum_PENDING_ADMIN_REVIEW,
]);

Serializer<NrpcFlagReviewStateEnum> _$nrpcFlagReviewStateEnumSerializer =
    _$NrpcFlagReviewStateEnumSerializer();

class _$NrpcFlagReviewStateEnumSerializer
    implements PrimitiveSerializer<NrpcFlagReviewStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
  };

  @override
  final Iterable<Type> types = const <Type>[NrpcFlagReviewStateEnum];
  @override
  final String wireName = 'NrpcFlagReviewStateEnum';

  @override
  Object serialize(Serializers serializers, NrpcFlagReviewStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NrpcFlagReviewStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NrpcFlagReviewStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NrpcFlag extends NrpcFlag {
  @override
  final NrpcFlagReviewStateEnum reviewState;
  @override
  final String reason;
  @override
  final DateTime? flaggedAt;

  factory _$NrpcFlag([void Function(NrpcFlagBuilder)? updates]) =>
      (NrpcFlagBuilder()..update(updates))._build();

  _$NrpcFlag._(
      {required this.reviewState, required this.reason, this.flaggedAt})
      : super._();
  @override
  NrpcFlag rebuild(void Function(NrpcFlagBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcFlagBuilder toBuilder() => NrpcFlagBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcFlag &&
        reviewState == other.reviewState &&
        reason == other.reason &&
        flaggedAt == other.flaggedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewState.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, flaggedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcFlag')
          ..add('reviewState', reviewState)
          ..add('reason', reason)
          ..add('flaggedAt', flaggedAt))
        .toString();
  }
}

class NrpcFlagBuilder implements Builder<NrpcFlag, NrpcFlagBuilder> {
  _$NrpcFlag? _$v;

  NrpcFlagReviewStateEnum? _reviewState;
  NrpcFlagReviewStateEnum? get reviewState => _$this._reviewState;
  set reviewState(NrpcFlagReviewStateEnum? reviewState) =>
      _$this._reviewState = reviewState;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _flaggedAt;
  DateTime? get flaggedAt => _$this._flaggedAt;
  set flaggedAt(DateTime? flaggedAt) => _$this._flaggedAt = flaggedAt;

  NrpcFlagBuilder() {
    NrpcFlag._defaults(this);
  }

  NrpcFlagBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewState = $v.reviewState;
      _reason = $v.reason;
      _flaggedAt = $v.flaggedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcFlag other) {
    _$v = other as _$NrpcFlag;
  }

  @override
  void update(void Function(NrpcFlagBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcFlag build() => _build();

  _$NrpcFlag _build() {
    final _$result = _$v ??
        _$NrpcFlag._(
          reviewState: BuiltValueNullFieldError.checkNotNull(
              reviewState, r'NrpcFlag', 'reviewState'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'NrpcFlag', 'reason'),
          flaggedAt: flaggedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
