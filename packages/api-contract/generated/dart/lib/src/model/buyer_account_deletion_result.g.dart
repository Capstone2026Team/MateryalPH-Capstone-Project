// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_account_deletion_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAccountDeletionResult extends BuyerAccountDeletionResult {
  @override
  final String reference;
  @override
  final DateTime deletedAt;
  @override
  final bool signInRequired;

  factory _$BuyerAccountDeletionResult(
          [void Function(BuyerAccountDeletionResultBuilder)? updates]) =>
      (BuyerAccountDeletionResultBuilder()..update(updates))._build();

  _$BuyerAccountDeletionResult._(
      {required this.reference,
      required this.deletedAt,
      required this.signInRequired})
      : super._();
  @override
  BuyerAccountDeletionResult rebuild(
          void Function(BuyerAccountDeletionResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAccountDeletionResultBuilder toBuilder() =>
      BuyerAccountDeletionResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAccountDeletionResult &&
        reference == other.reference &&
        deletedAt == other.deletedAt &&
        signInRequired == other.signInRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jc(_$hash, signInRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAccountDeletionResult')
          ..add('reference', reference)
          ..add('deletedAt', deletedAt)
          ..add('signInRequired', signInRequired))
        .toString();
  }
}

class BuyerAccountDeletionResultBuilder
    implements
        Builder<BuyerAccountDeletionResult, BuyerAccountDeletionResultBuilder> {
  _$BuyerAccountDeletionResult? _$v;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  bool? _signInRequired;
  bool? get signInRequired => _$this._signInRequired;
  set signInRequired(bool? signInRequired) =>
      _$this._signInRequired = signInRequired;

  BuyerAccountDeletionResultBuilder() {
    BuyerAccountDeletionResult._defaults(this);
  }

  BuyerAccountDeletionResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reference = $v.reference;
      _deletedAt = $v.deletedAt;
      _signInRequired = $v.signInRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAccountDeletionResult other) {
    _$v = other as _$BuyerAccountDeletionResult;
  }

  @override
  void update(void Function(BuyerAccountDeletionResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAccountDeletionResult build() => _build();

  _$BuyerAccountDeletionResult _build() {
    final _$result = _$v ??
        _$BuyerAccountDeletionResult._(
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'BuyerAccountDeletionResult', 'reference'),
          deletedAt: BuiltValueNullFieldError.checkNotNull(
              deletedAt, r'BuyerAccountDeletionResult', 'deletedAt'),
          signInRequired: BuiltValueNullFieldError.checkNotNull(
              signInRequired, r'BuyerAccountDeletionResult', 'signInRequired'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
