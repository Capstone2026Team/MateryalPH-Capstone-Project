// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationPreference extends NotificationPreference {
  @override
  final String category;
  @override
  final bool mandatory;
  @override
  final String explanation;
  @override
  final bool inApp;
  @override
  final bool email;
  @override
  final bool push;

  factory _$NotificationPreference(
          [void Function(NotificationPreferenceBuilder)? updates]) =>
      (NotificationPreferenceBuilder()..update(updates))._build();

  _$NotificationPreference._(
      {required this.category,
      required this.mandatory,
      required this.explanation,
      required this.inApp,
      required this.email,
      required this.push})
      : super._();
  @override
  NotificationPreference rebuild(
          void Function(NotificationPreferenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationPreferenceBuilder toBuilder() =>
      NotificationPreferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationPreference &&
        category == other.category &&
        mandatory == other.mandatory &&
        explanation == other.explanation &&
        inApp == other.inApp &&
        email == other.email &&
        push == other.push;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, mandatory.hashCode);
    _$hash = $jc(_$hash, explanation.hashCode);
    _$hash = $jc(_$hash, inApp.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, push.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationPreference')
          ..add('category', category)
          ..add('mandatory', mandatory)
          ..add('explanation', explanation)
          ..add('inApp', inApp)
          ..add('email', email)
          ..add('push', push))
        .toString();
  }
}

class NotificationPreferenceBuilder
    implements Builder<NotificationPreference, NotificationPreferenceBuilder> {
  _$NotificationPreference? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  bool? _mandatory;
  bool? get mandatory => _$this._mandatory;
  set mandatory(bool? mandatory) => _$this._mandatory = mandatory;

  String? _explanation;
  String? get explanation => _$this._explanation;
  set explanation(String? explanation) => _$this._explanation = explanation;

  bool? _inApp;
  bool? get inApp => _$this._inApp;
  set inApp(bool? inApp) => _$this._inApp = inApp;

  bool? _email;
  bool? get email => _$this._email;
  set email(bool? email) => _$this._email = email;

  bool? _push;
  bool? get push => _$this._push;
  set push(bool? push) => _$this._push = push;

  NotificationPreferenceBuilder() {
    NotificationPreference._defaults(this);
  }

  NotificationPreferenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _mandatory = $v.mandatory;
      _explanation = $v.explanation;
      _inApp = $v.inApp;
      _email = $v.email;
      _push = $v.push;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationPreference other) {
    _$v = other as _$NotificationPreference;
  }

  @override
  void update(void Function(NotificationPreferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationPreference build() => _build();

  _$NotificationPreference _build() {
    final _$result = _$v ??
        _$NotificationPreference._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'NotificationPreference', 'category'),
          mandatory: BuiltValueNullFieldError.checkNotNull(
              mandatory, r'NotificationPreference', 'mandatory'),
          explanation: BuiltValueNullFieldError.checkNotNull(
              explanation, r'NotificationPreference', 'explanation'),
          inApp: BuiltValueNullFieldError.checkNotNull(
              inApp, r'NotificationPreference', 'inApp'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'NotificationPreference', 'email'),
          push: BuiltValueNullFieldError.checkNotNull(
              push, r'NotificationPreference', 'push'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
