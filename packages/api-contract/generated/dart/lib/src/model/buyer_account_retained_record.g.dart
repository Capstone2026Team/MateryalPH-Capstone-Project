// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_account_retained_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAccountRetainedRecord extends BuyerAccountRetainedRecord {
  @override
  final String category;
  @override
  final String purpose;

  factory _$BuyerAccountRetainedRecord(
          [void Function(BuyerAccountRetainedRecordBuilder)? updates]) =>
      (BuyerAccountRetainedRecordBuilder()..update(updates))._build();

  _$BuyerAccountRetainedRecord._(
      {required this.category, required this.purpose})
      : super._();
  @override
  BuyerAccountRetainedRecord rebuild(
          void Function(BuyerAccountRetainedRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAccountRetainedRecordBuilder toBuilder() =>
      BuyerAccountRetainedRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAccountRetainedRecord &&
        category == other.category &&
        purpose == other.purpose;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAccountRetainedRecord')
          ..add('category', category)
          ..add('purpose', purpose))
        .toString();
  }
}

class BuyerAccountRetainedRecordBuilder
    implements
        Builder<BuyerAccountRetainedRecord, BuyerAccountRetainedRecordBuilder> {
  _$BuyerAccountRetainedRecord? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  BuyerAccountRetainedRecordBuilder() {
    BuyerAccountRetainedRecord._defaults(this);
  }

  BuyerAccountRetainedRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _purpose = $v.purpose;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAccountRetainedRecord other) {
    _$v = other as _$BuyerAccountRetainedRecord;
  }

  @override
  void update(void Function(BuyerAccountRetainedRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAccountRetainedRecord build() => _build();

  _$BuyerAccountRetainedRecord _build() {
    final _$result = _$v ??
        _$BuyerAccountRetainedRecord._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'BuyerAccountRetainedRecord', 'category'),
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose, r'BuyerAccountRetainedRecord', 'purpose'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
