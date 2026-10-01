// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_publish.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatPublish extends ChatPublish {
  @override
  final int lockVersion;

  factory _$ChatPublish([void Function(ChatPublishBuilder)? updates]) =>
      (ChatPublishBuilder()..update(updates))._build();

  _$ChatPublish._({required this.lockVersion}) : super._();
  @override
  ChatPublish rebuild(void Function(ChatPublishBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatPublishBuilder toBuilder() => ChatPublishBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatPublish && lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatPublish')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class ChatPublishBuilder implements Builder<ChatPublish, ChatPublishBuilder> {
  _$ChatPublish? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ChatPublishBuilder() {
    ChatPublish._defaults(this);
  }

  ChatPublishBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatPublish other) {
    _$v = other as _$ChatPublish;
  }

  @override
  void update(void Function(ChatPublishBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatPublish build() => _build();

  _$ChatPublish _build() {
    final _$result = _$v ??
        _$ChatPublish._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ChatPublish', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
