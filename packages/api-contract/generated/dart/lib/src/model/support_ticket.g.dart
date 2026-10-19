// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportTicket extends SupportTicket {
  @override
  final String id;
  @override
  final String ticketNumber;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final SupportUserType userType;
  @override
  final SupportCategory category;
  @override
  final String subject;
  @override
  final String? referenceType;
  @override
  final String? reference;
  @override
  final SupportStatus status;
  @override
  final String? assignedAdminId;
  @override
  final String? assignedAdminName;
  @override
  final int lockVersion;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$SupportTicket([void Function(SupportTicketBuilder)? updates]) =>
      (SupportTicketBuilder()..update(updates))._build();

  _$SupportTicket._(
      {required this.id,
      required this.ticketNumber,
      required this.fullName,
      required this.email,
      required this.userType,
      required this.category,
      required this.subject,
      this.referenceType,
      this.reference,
      required this.status,
      this.assignedAdminId,
      this.assignedAdminName,
      required this.lockVersion,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  SupportTicket rebuild(void Function(SupportTicketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportTicketBuilder toBuilder() => SupportTicketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportTicket &&
        id == other.id &&
        ticketNumber == other.ticketNumber &&
        fullName == other.fullName &&
        email == other.email &&
        userType == other.userType &&
        category == other.category &&
        subject == other.subject &&
        referenceType == other.referenceType &&
        reference == other.reference &&
        status == other.status &&
        assignedAdminId == other.assignedAdminId &&
        assignedAdminName == other.assignedAdminName &&
        lockVersion == other.lockVersion &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ticketNumber.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, userType.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, referenceType.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, assignedAdminId.hashCode);
    _$hash = $jc(_$hash, assignedAdminName.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportTicket')
          ..add('id', id)
          ..add('ticketNumber', ticketNumber)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('userType', userType)
          ..add('category', category)
          ..add('subject', subject)
          ..add('referenceType', referenceType)
          ..add('reference', reference)
          ..add('status', status)
          ..add('assignedAdminId', assignedAdminId)
          ..add('assignedAdminName', assignedAdminName)
          ..add('lockVersion', lockVersion)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class SupportTicketBuilder
    implements Builder<SupportTicket, SupportTicketBuilder> {
  _$SupportTicket? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _ticketNumber;
  String? get ticketNumber => _$this._ticketNumber;
  set ticketNumber(String? ticketNumber) => _$this._ticketNumber = ticketNumber;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  SupportUserType? _userType;
  SupportUserType? get userType => _$this._userType;
  set userType(SupportUserType? userType) => _$this._userType = userType;

  SupportCategory? _category;
  SupportCategory? get category => _$this._category;
  set category(SupportCategory? category) => _$this._category = category;

  String? _subject;
  String? get subject => _$this._subject;
  set subject(String? subject) => _$this._subject = subject;

  String? _referenceType;
  String? get referenceType => _$this._referenceType;
  set referenceType(String? referenceType) =>
      _$this._referenceType = referenceType;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  SupportStatus? _status;
  SupportStatus? get status => _$this._status;
  set status(SupportStatus? status) => _$this._status = status;

  String? _assignedAdminId;
  String? get assignedAdminId => _$this._assignedAdminId;
  set assignedAdminId(String? assignedAdminId) =>
      _$this._assignedAdminId = assignedAdminId;

  String? _assignedAdminName;
  String? get assignedAdminName => _$this._assignedAdminName;
  set assignedAdminName(String? assignedAdminName) =>
      _$this._assignedAdminName = assignedAdminName;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  SupportTicketBuilder() {
    SupportTicket._defaults(this);
  }

  SupportTicketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ticketNumber = $v.ticketNumber;
      _fullName = $v.fullName;
      _email = $v.email;
      _userType = $v.userType;
      _category = $v.category;
      _subject = $v.subject;
      _referenceType = $v.referenceType;
      _reference = $v.reference;
      _status = $v.status;
      _assignedAdminId = $v.assignedAdminId;
      _assignedAdminName = $v.assignedAdminName;
      _lockVersion = $v.lockVersion;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportTicket other) {
    _$v = other as _$SupportTicket;
  }

  @override
  void update(void Function(SupportTicketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportTicket build() => _build();

  _$SupportTicket _build() {
    final _$result = _$v ??
        _$SupportTicket._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'SupportTicket', 'id'),
          ticketNumber: BuiltValueNullFieldError.checkNotNull(
              ticketNumber, r'SupportTicket', 'ticketNumber'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'SupportTicket', 'fullName'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'SupportTicket', 'email'),
          userType: BuiltValueNullFieldError.checkNotNull(
              userType, r'SupportTicket', 'userType'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'SupportTicket', 'category'),
          subject: BuiltValueNullFieldError.checkNotNull(
              subject, r'SupportTicket', 'subject'),
          referenceType: referenceType,
          reference: reference,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SupportTicket', 'status'),
          assignedAdminId: assignedAdminId,
          assignedAdminName: assignedAdminName,
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'SupportTicket', 'lockVersion'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'SupportTicket', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'SupportTicket', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
