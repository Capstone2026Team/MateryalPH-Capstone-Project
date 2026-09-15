// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_agreement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountAgreement extends AccountAgreement {
  @override
  final String id;
  @override
  final String code;
  @override
  final String title;
  @override
  final int version;
  @override
  final String? content;
  @override
  final bool contentAvailable;
  @override
  final String? acceptedAt;
  @override
  final bool requiresAcceptance;

  factory _$AccountAgreement(
          [void Function(AccountAgreementBuilder)? updates]) =>
      (AccountAgreementBuilder()..update(updates))._build();

  _$AccountAgreement._(
      {required this.id,
      required this.code,
      required this.title,
      required this.version,
      this.content,
      required this.contentAvailable,
      this.acceptedAt,
      required this.requiresAcceptance})
      : super._();
  @override
  AccountAgreement rebuild(void Function(AccountAgreementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountAgreementBuilder toBuilder() =>
      AccountAgreementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountAgreement &&
        id == other.id &&
        code == other.code &&
        title == other.title &&
        version == other.version &&
        content == other.content &&
        contentAvailable == other.contentAvailable &&
        acceptedAt == other.acceptedAt &&
        requiresAcceptance == other.requiresAcceptance;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, contentAvailable.hashCode);
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jc(_$hash, requiresAcceptance.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountAgreement')
          ..add('id', id)
          ..add('code', code)
          ..add('title', title)
          ..add('version', version)
          ..add('content', content)
          ..add('contentAvailable', contentAvailable)
          ..add('acceptedAt', acceptedAt)
          ..add('requiresAcceptance', requiresAcceptance))
        .toString();
  }
}

class AccountAgreementBuilder
    implements Builder<AccountAgreement, AccountAgreementBuilder> {
  _$AccountAgreement? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  bool? _contentAvailable;
  bool? get contentAvailable => _$this._contentAvailable;
  set contentAvailable(bool? contentAvailable) =>
      _$this._contentAvailable = contentAvailable;

  String? _acceptedAt;
  String? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(String? acceptedAt) => _$this._acceptedAt = acceptedAt;

  bool? _requiresAcceptance;
  bool? get requiresAcceptance => _$this._requiresAcceptance;
  set requiresAcceptance(bool? requiresAcceptance) =>
      _$this._requiresAcceptance = requiresAcceptance;

  AccountAgreementBuilder() {
    AccountAgreement._defaults(this);
  }

  AccountAgreementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _title = $v.title;
      _version = $v.version;
      _content = $v.content;
      _contentAvailable = $v.contentAvailable;
      _acceptedAt = $v.acceptedAt;
      _requiresAcceptance = $v.requiresAcceptance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountAgreement other) {
    _$v = other as _$AccountAgreement;
  }

  @override
  void update(void Function(AccountAgreementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountAgreement build() => _build();

  _$AccountAgreement _build() {
    final _$result = _$v ??
        _$AccountAgreement._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AccountAgreement', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AccountAgreement', 'code'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'AccountAgreement', 'title'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'AccountAgreement', 'version'),
          content: content,
          contentAvailable: BuiltValueNullFieldError.checkNotNull(
              contentAvailable, r'AccountAgreement', 'contentAvailable'),
          acceptedAt: acceptedAt,
          requiresAcceptance: BuiltValueNullFieldError.checkNotNull(
              requiresAcceptance, r'AccountAgreement', 'requiresAcceptance'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
