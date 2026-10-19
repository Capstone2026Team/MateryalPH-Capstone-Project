// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupportEntryKindEnum _$supportEntryKindEnum_MESSAGE =
    const SupportEntryKindEnum._('MESSAGE');
const SupportEntryKindEnum _$supportEntryKindEnum_STATUS_CHANGED =
    const SupportEntryKindEnum._('STATUS_CHANGED');
const SupportEntryKindEnum _$supportEntryKindEnum_ASSIGNED =
    const SupportEntryKindEnum._('ASSIGNED');

SupportEntryKindEnum _$supportEntryKindEnumValueOf(String name) {
  switch (name) {
    case 'MESSAGE':
      return _$supportEntryKindEnum_MESSAGE;
    case 'STATUS_CHANGED':
      return _$supportEntryKindEnum_STATUS_CHANGED;
    case 'ASSIGNED':
      return _$supportEntryKindEnum_ASSIGNED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupportEntryKindEnum> _$supportEntryKindEnumValues =
    BuiltSet<SupportEntryKindEnum>(const <SupportEntryKindEnum>[
  _$supportEntryKindEnum_MESSAGE,
  _$supportEntryKindEnum_STATUS_CHANGED,
  _$supportEntryKindEnum_ASSIGNED,
]);

Serializer<SupportEntryKindEnum> _$supportEntryKindEnumSerializer =
    _$SupportEntryKindEnumSerializer();

class _$SupportEntryKindEnumSerializer
    implements PrimitiveSerializer<SupportEntryKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MESSAGE': 'MESSAGE',
    'STATUS_CHANGED': 'STATUS_CHANGED',
    'ASSIGNED': 'ASSIGNED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MESSAGE': 'MESSAGE',
    'STATUS_CHANGED': 'STATUS_CHANGED',
    'ASSIGNED': 'ASSIGNED',
  };

  @override
  final Iterable<Type> types = const <Type>[SupportEntryKindEnum];
  @override
  final String wireName = 'SupportEntryKindEnum';

  @override
  Object serialize(Serializers serializers, SupportEntryKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupportEntryKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupportEntryKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SupportEntry extends SupportEntry {
  @override
  final String id;
  @override
  final SupportEntryKindEnum kind;
  @override
  final String actorName;
  @override
  final String actorRole;
  @override
  final String body;
  @override
  final SupportEntryDetails details;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<SupportAttachment> attachments;

  factory _$SupportEntry([void Function(SupportEntryBuilder)? updates]) =>
      (SupportEntryBuilder()..update(updates))._build();

  _$SupportEntry._(
      {required this.id,
      required this.kind,
      required this.actorName,
      required this.actorRole,
      required this.body,
      required this.details,
      required this.createdAt,
      required this.attachments})
      : super._();
  @override
  SupportEntry rebuild(void Function(SupportEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportEntryBuilder toBuilder() => SupportEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportEntry &&
        id == other.id &&
        kind == other.kind &&
        actorName == other.actorName &&
        actorRole == other.actorRole &&
        body == other.body &&
        details == other.details &&
        createdAt == other.createdAt &&
        attachments == other.attachments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportEntry')
          ..add('id', id)
          ..add('kind', kind)
          ..add('actorName', actorName)
          ..add('actorRole', actorRole)
          ..add('body', body)
          ..add('details', details)
          ..add('createdAt', createdAt)
          ..add('attachments', attachments))
        .toString();
  }
}

class SupportEntryBuilder
    implements Builder<SupportEntry, SupportEntryBuilder> {
  _$SupportEntry? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  SupportEntryKindEnum? _kind;
  SupportEntryKindEnum? get kind => _$this._kind;
  set kind(SupportEntryKindEnum? kind) => _$this._kind = kind;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  SupportEntryDetailsBuilder? _details;
  SupportEntryDetailsBuilder get details =>
      _$this._details ??= SupportEntryDetailsBuilder();
  set details(SupportEntryDetailsBuilder? details) => _$this._details = details;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<SupportAttachment>? _attachments;
  ListBuilder<SupportAttachment> get attachments =>
      _$this._attachments ??= ListBuilder<SupportAttachment>();
  set attachments(ListBuilder<SupportAttachment>? attachments) =>
      _$this._attachments = attachments;

  SupportEntryBuilder() {
    SupportEntry._defaults(this);
  }

  SupportEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _actorName = $v.actorName;
      _actorRole = $v.actorRole;
      _body = $v.body;
      _details = $v.details.toBuilder();
      _createdAt = $v.createdAt;
      _attachments = $v.attachments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportEntry other) {
    _$v = other as _$SupportEntry;
  }

  @override
  void update(void Function(SupportEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportEntry build() => _build();

  _$SupportEntry _build() {
    _$SupportEntry _$result;
    try {
      _$result = _$v ??
          _$SupportEntry._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SupportEntry', 'id'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'SupportEntry', 'kind'),
            actorName: BuiltValueNullFieldError.checkNotNull(
                actorName, r'SupportEntry', 'actorName'),
            actorRole: BuiltValueNullFieldError.checkNotNull(
                actorRole, r'SupportEntry', 'actorRole'),
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'SupportEntry', 'body'),
            details: details.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'SupportEntry', 'createdAt'),
            attachments: attachments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        details.build();

        _$failedField = 'attachments';
        attachments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SupportEntry', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
