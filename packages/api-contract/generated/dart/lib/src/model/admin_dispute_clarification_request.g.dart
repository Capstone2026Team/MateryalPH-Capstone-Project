// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dispute_clarification_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDisputeClarificationRequestPartiesEnum
    _$adminDisputeClarificationRequestPartiesEnum_BUYER =
    const AdminDisputeClarificationRequestPartiesEnum._('BUYER');
const AdminDisputeClarificationRequestPartiesEnum
    _$adminDisputeClarificationRequestPartiesEnum_VENDOR =
    const AdminDisputeClarificationRequestPartiesEnum._('VENDOR');

AdminDisputeClarificationRequestPartiesEnum
    _$adminDisputeClarificationRequestPartiesEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$adminDisputeClarificationRequestPartiesEnum_BUYER;
    case 'VENDOR':
      return _$adminDisputeClarificationRequestPartiesEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDisputeClarificationRequestPartiesEnum>
    _$adminDisputeClarificationRequestPartiesEnumValues = BuiltSet<
        AdminDisputeClarificationRequestPartiesEnum>(const <AdminDisputeClarificationRequestPartiesEnum>[
  _$adminDisputeClarificationRequestPartiesEnum_BUYER,
  _$adminDisputeClarificationRequestPartiesEnum_VENDOR,
]);

Serializer<AdminDisputeClarificationRequestPartiesEnum>
    _$adminDisputeClarificationRequestPartiesEnumSerializer =
    _$AdminDisputeClarificationRequestPartiesEnumSerializer();

class _$AdminDisputeClarificationRequestPartiesEnumSerializer
    implements
        PrimitiveSerializer<AdminDisputeClarificationRequestPartiesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDisputeClarificationRequestPartiesEnum
  ];
  @override
  final String wireName = 'AdminDisputeClarificationRequestPartiesEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDisputeClarificationRequestPartiesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDisputeClarificationRequestPartiesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDisputeClarificationRequestPartiesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDisputeClarificationRequest
    extends AdminDisputeClarificationRequest {
  @override
  final BuiltList<AdminDisputeClarificationRequestPartiesEnum> parties;
  @override
  final String question;

  factory _$AdminDisputeClarificationRequest(
          [void Function(AdminDisputeClarificationRequestBuilder)? updates]) =>
      (AdminDisputeClarificationRequestBuilder()..update(updates))._build();

  _$AdminDisputeClarificationRequest._(
      {required this.parties, required this.question})
      : super._();
  @override
  AdminDisputeClarificationRequest rebuild(
          void Function(AdminDisputeClarificationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDisputeClarificationRequestBuilder toBuilder() =>
      AdminDisputeClarificationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDisputeClarificationRequest &&
        parties == other.parties &&
        question == other.question;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, parties.hashCode);
    _$hash = $jc(_$hash, question.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDisputeClarificationRequest')
          ..add('parties', parties)
          ..add('question', question))
        .toString();
  }
}

class AdminDisputeClarificationRequestBuilder
    implements
        Builder<AdminDisputeClarificationRequest,
            AdminDisputeClarificationRequestBuilder> {
  _$AdminDisputeClarificationRequest? _$v;

  ListBuilder<AdminDisputeClarificationRequestPartiesEnum>? _parties;
  ListBuilder<AdminDisputeClarificationRequestPartiesEnum> get parties =>
      _$this._parties ??=
          ListBuilder<AdminDisputeClarificationRequestPartiesEnum>();
  set parties(
          ListBuilder<AdminDisputeClarificationRequestPartiesEnum>? parties) =>
      _$this._parties = parties;

  String? _question;
  String? get question => _$this._question;
  set question(String? question) => _$this._question = question;

  AdminDisputeClarificationRequestBuilder() {
    AdminDisputeClarificationRequest._defaults(this);
  }

  AdminDisputeClarificationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _parties = $v.parties.toBuilder();
      _question = $v.question;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDisputeClarificationRequest other) {
    _$v = other as _$AdminDisputeClarificationRequest;
  }

  @override
  void update(void Function(AdminDisputeClarificationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDisputeClarificationRequest build() => _build();

  _$AdminDisputeClarificationRequest _build() {
    _$AdminDisputeClarificationRequest _$result;
    try {
      _$result = _$v ??
          _$AdminDisputeClarificationRequest._(
            parties: parties.build(),
            question: BuiltValueNullFieldError.checkNotNull(
                question, r'AdminDisputeClarificationRequest', 'question'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parties';
        parties.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDisputeClarificationRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
