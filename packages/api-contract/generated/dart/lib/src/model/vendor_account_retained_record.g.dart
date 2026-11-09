// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_account_retained_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorAccountRetainedRecord extends VendorAccountRetainedRecord {
  @override
  final String category;
  @override
  final String purpose;

  factory _$VendorAccountRetainedRecord(
          [void Function(VendorAccountRetainedRecordBuilder)? updates]) =>
      (VendorAccountRetainedRecordBuilder()..update(updates))._build();

  _$VendorAccountRetainedRecord._(
      {required this.category, required this.purpose})
      : super._();
  @override
  VendorAccountRetainedRecord rebuild(
          void Function(VendorAccountRetainedRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAccountRetainedRecordBuilder toBuilder() =>
      VendorAccountRetainedRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAccountRetainedRecord &&
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
    return (newBuiltValueToStringHelper(r'VendorAccountRetainedRecord')
          ..add('category', category)
          ..add('purpose', purpose))
        .toString();
  }
}

class VendorAccountRetainedRecordBuilder
    implements
        Builder<VendorAccountRetainedRecord,
            VendorAccountRetainedRecordBuilder> {
  _$VendorAccountRetainedRecord? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  VendorAccountRetainedRecordBuilder() {
    VendorAccountRetainedRecord._defaults(this);
  }

  VendorAccountRetainedRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _purpose = $v.purpose;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorAccountRetainedRecord other) {
    _$v = other as _$VendorAccountRetainedRecord;
  }

  @override
  void update(void Function(VendorAccountRetainedRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAccountRetainedRecord build() => _build();

  _$VendorAccountRetainedRecord _build() {
    final _$result = _$v ??
        _$VendorAccountRetainedRecord._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'VendorAccountRetainedRecord', 'category'),
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose, r'VendorAccountRetainedRecord', 'purpose'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
