// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_access_email.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportAccessEmail extends SupportAccessEmail {
  @override
  final String ticketNumber;
  @override
  final String email;
  @override
  final String? website;

  factory _$SupportAccessEmail(
          [void Function(SupportAccessEmailBuilder)? updates]) =>
      (SupportAccessEmailBuilder()..update(updates))._build();

  _$SupportAccessEmail._(
      {required this.ticketNumber, required this.email, this.website})
      : super._();
  @override
  SupportAccessEmail rebuild(
          void Function(SupportAccessEmailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportAccessEmailBuilder toBuilder() =>
      SupportAccessEmailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportAccessEmail &&
        ticketNumber == other.ticketNumber &&
        email == other.email &&
        website == other.website;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketNumber.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, website.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportAccessEmail')
          ..add('ticketNumber', ticketNumber)
          ..add('email', email)
          ..add('website', website))
        .toString();
  }
}

class SupportAccessEmailBuilder
    implements Builder<SupportAccessEmail, SupportAccessEmailBuilder> {
  _$SupportAccessEmail? _$v;

  String? _ticketNumber;
  String? get ticketNumber => _$this._ticketNumber;
  set ticketNumber(String? ticketNumber) => _$this._ticketNumber = ticketNumber;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _website;
  String? get website => _$this._website;
  set website(String? website) => _$this._website = website;

  SupportAccessEmailBuilder() {
    SupportAccessEmail._defaults(this);
  }

  SupportAccessEmailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketNumber = $v.ticketNumber;
      _email = $v.email;
      _website = $v.website;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportAccessEmail other) {
    _$v = other as _$SupportAccessEmail;
  }

  @override
  void update(void Function(SupportAccessEmailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportAccessEmail build() => _build();

  _$SupportAccessEmail _build() {
    final _$result = _$v ??
        _$SupportAccessEmail._(
          ticketNumber: BuiltValueNullFieldError.checkNotNull(
              ticketNumber, r'SupportAccessEmail', 'ticketNumber'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'SupportAccessEmail', 'email'),
          website: website,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
