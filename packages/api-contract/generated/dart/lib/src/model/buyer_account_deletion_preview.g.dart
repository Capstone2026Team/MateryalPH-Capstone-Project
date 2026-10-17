// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_account_deletion_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAccountDeletionPreview extends BuyerAccountDeletionPreview {
  @override
  final bool canDelete;
  @override
  final BuyerAccountDeletionBlockers blockers;
  @override
  final BuiltList<BuyerAccountRetainedRecord> retainedRecords;
  @override
  final String confirmationPhrase;

  factory _$BuyerAccountDeletionPreview(
          [void Function(BuyerAccountDeletionPreviewBuilder)? updates]) =>
      (BuyerAccountDeletionPreviewBuilder()..update(updates))._build();

  _$BuyerAccountDeletionPreview._(
      {required this.canDelete,
      required this.blockers,
      required this.retainedRecords,
      required this.confirmationPhrase})
      : super._();
  @override
  BuyerAccountDeletionPreview rebuild(
          void Function(BuyerAccountDeletionPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAccountDeletionPreviewBuilder toBuilder() =>
      BuyerAccountDeletionPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAccountDeletionPreview &&
        canDelete == other.canDelete &&
        blockers == other.blockers &&
        retainedRecords == other.retainedRecords &&
        confirmationPhrase == other.confirmationPhrase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canDelete.hashCode);
    _$hash = $jc(_$hash, blockers.hashCode);
    _$hash = $jc(_$hash, retainedRecords.hashCode);
    _$hash = $jc(_$hash, confirmationPhrase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAccountDeletionPreview')
          ..add('canDelete', canDelete)
          ..add('blockers', blockers)
          ..add('retainedRecords', retainedRecords)
          ..add('confirmationPhrase', confirmationPhrase))
        .toString();
  }
}

class BuyerAccountDeletionPreviewBuilder
    implements
        Builder<BuyerAccountDeletionPreview,
            BuyerAccountDeletionPreviewBuilder> {
  _$BuyerAccountDeletionPreview? _$v;

  bool? _canDelete;
  bool? get canDelete => _$this._canDelete;
  set canDelete(bool? canDelete) => _$this._canDelete = canDelete;

  BuyerAccountDeletionBlockersBuilder? _blockers;
  BuyerAccountDeletionBlockersBuilder get blockers =>
      _$this._blockers ??= BuyerAccountDeletionBlockersBuilder();
  set blockers(BuyerAccountDeletionBlockersBuilder? blockers) =>
      _$this._blockers = blockers;

  ListBuilder<BuyerAccountRetainedRecord>? _retainedRecords;
  ListBuilder<BuyerAccountRetainedRecord> get retainedRecords =>
      _$this._retainedRecords ??= ListBuilder<BuyerAccountRetainedRecord>();
  set retainedRecords(
          ListBuilder<BuyerAccountRetainedRecord>? retainedRecords) =>
      _$this._retainedRecords = retainedRecords;

  String? _confirmationPhrase;
  String? get confirmationPhrase => _$this._confirmationPhrase;
  set confirmationPhrase(String? confirmationPhrase) =>
      _$this._confirmationPhrase = confirmationPhrase;

  BuyerAccountDeletionPreviewBuilder() {
    BuyerAccountDeletionPreview._defaults(this);
  }

  BuyerAccountDeletionPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canDelete = $v.canDelete;
      _blockers = $v.blockers.toBuilder();
      _retainedRecords = $v.retainedRecords.toBuilder();
      _confirmationPhrase = $v.confirmationPhrase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAccountDeletionPreview other) {
    _$v = other as _$BuyerAccountDeletionPreview;
  }

  @override
  void update(void Function(BuyerAccountDeletionPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAccountDeletionPreview build() => _build();

  _$BuyerAccountDeletionPreview _build() {
    _$BuyerAccountDeletionPreview _$result;
    try {
      _$result = _$v ??
          _$BuyerAccountDeletionPreview._(
            canDelete: BuiltValueNullFieldError.checkNotNull(
                canDelete, r'BuyerAccountDeletionPreview', 'canDelete'),
            blockers: blockers.build(),
            retainedRecords: retainedRecords.build(),
            confirmationPhrase: BuiltValueNullFieldError.checkNotNull(
                confirmationPhrase,
                r'BuyerAccountDeletionPreview',
                'confirmationPhrase'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'blockers';
        blockers.build();
        _$failedField = 'retainedRecords';
        retainedRecords.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerAccountDeletionPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
