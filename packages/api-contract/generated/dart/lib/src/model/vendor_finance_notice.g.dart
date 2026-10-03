// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_finance_notice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFinanceNotice extends VendorFinanceNotice {
  @override
  final String id;
  @override
  final bool mandatory;
  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime? createdAt;
  @override
  final bool read;

  factory _$VendorFinanceNotice(
          [void Function(VendorFinanceNoticeBuilder)? updates]) =>
      (VendorFinanceNoticeBuilder()..update(updates))._build();

  _$VendorFinanceNotice._(
      {required this.id,
      required this.mandatory,
      required this.title,
      required this.body,
      this.createdAt,
      required this.read})
      : super._();
  @override
  VendorFinanceNotice rebuild(
          void Function(VendorFinanceNoticeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFinanceNoticeBuilder toBuilder() =>
      VendorFinanceNoticeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFinanceNotice &&
        id == other.id &&
        mandatory == other.mandatory &&
        title == other.title &&
        body == other.body &&
        createdAt == other.createdAt &&
        read == other.read;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mandatory.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, read.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorFinanceNotice')
          ..add('id', id)
          ..add('mandatory', mandatory)
          ..add('title', title)
          ..add('body', body)
          ..add('createdAt', createdAt)
          ..add('read', read))
        .toString();
  }
}

class VendorFinanceNoticeBuilder
    implements Builder<VendorFinanceNotice, VendorFinanceNoticeBuilder> {
  _$VendorFinanceNotice? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _mandatory;
  bool? get mandatory => _$this._mandatory;
  set mandatory(bool? mandatory) => _$this._mandatory = mandatory;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  bool? _read;
  bool? get read => _$this._read;
  set read(bool? read) => _$this._read = read;

  VendorFinanceNoticeBuilder() {
    VendorFinanceNotice._defaults(this);
  }

  VendorFinanceNoticeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _mandatory = $v.mandatory;
      _title = $v.title;
      _body = $v.body;
      _createdAt = $v.createdAt;
      _read = $v.read;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorFinanceNotice other) {
    _$v = other as _$VendorFinanceNotice;
  }

  @override
  void update(void Function(VendorFinanceNoticeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFinanceNotice build() => _build();

  _$VendorFinanceNotice _build() {
    final _$result = _$v ??
        _$VendorFinanceNotice._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorFinanceNotice', 'id'),
          mandatory: BuiltValueNullFieldError.checkNotNull(
              mandatory, r'VendorFinanceNotice', 'mandatory'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'VendorFinanceNotice', 'title'),
          body: BuiltValueNullFieldError.checkNotNull(
              body, r'VendorFinanceNotice', 'body'),
          createdAt: createdAt,
          read: BuiltValueNullFieldError.checkNotNull(
              read, r'VendorFinanceNotice', 'read'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
