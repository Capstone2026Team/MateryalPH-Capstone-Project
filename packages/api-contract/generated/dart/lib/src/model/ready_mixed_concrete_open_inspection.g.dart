// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready_mixed_concrete_open_inspection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReadyMixedConcreteOpenInspectionStatusEnum
    _$readyMixedConcreteOpenInspectionStatusEnum_REQUESTED =
    const ReadyMixedConcreteOpenInspectionStatusEnum._('REQUESTED');
const ReadyMixedConcreteOpenInspectionStatusEnum
    _$readyMixedConcreteOpenInspectionStatusEnum_SCHEDULED =
    const ReadyMixedConcreteOpenInspectionStatusEnum._('SCHEDULED');

ReadyMixedConcreteOpenInspectionStatusEnum
    _$readyMixedConcreteOpenInspectionStatusEnumValueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$readyMixedConcreteOpenInspectionStatusEnum_REQUESTED;
    case 'SCHEDULED':
      return _$readyMixedConcreteOpenInspectionStatusEnum_SCHEDULED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReadyMixedConcreteOpenInspectionStatusEnum>
    _$readyMixedConcreteOpenInspectionStatusEnumValues = BuiltSet<
        ReadyMixedConcreteOpenInspectionStatusEnum>(const <ReadyMixedConcreteOpenInspectionStatusEnum>[
  _$readyMixedConcreteOpenInspectionStatusEnum_REQUESTED,
  _$readyMixedConcreteOpenInspectionStatusEnum_SCHEDULED,
]);

Serializer<ReadyMixedConcreteOpenInspectionStatusEnum>
    _$readyMixedConcreteOpenInspectionStatusEnumSerializer =
    _$ReadyMixedConcreteOpenInspectionStatusEnumSerializer();

class _$ReadyMixedConcreteOpenInspectionStatusEnumSerializer
    implements PrimitiveSerializer<ReadyMixedConcreteOpenInspectionStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUESTED': 'REQUESTED',
    'SCHEDULED': 'SCHEDULED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUESTED': 'REQUESTED',
    'SCHEDULED': 'SCHEDULED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ReadyMixedConcreteOpenInspectionStatusEnum
  ];
  @override
  final String wireName = 'ReadyMixedConcreteOpenInspectionStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ReadyMixedConcreteOpenInspectionStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadyMixedConcreteOpenInspectionStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadyMixedConcreteOpenInspectionStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadyMixedConcreteOpenInspection
    extends ReadyMixedConcreteOpenInspection {
  @override
  final String id;
  @override
  final ReadyMixedConcreteOpenInspectionStatusEnum status;
  @override
  final String conversationId;

  factory _$ReadyMixedConcreteOpenInspection(
          [void Function(ReadyMixedConcreteOpenInspectionBuilder)? updates]) =>
      (ReadyMixedConcreteOpenInspectionBuilder()..update(updates))._build();

  _$ReadyMixedConcreteOpenInspection._(
      {required this.id, required this.status, required this.conversationId})
      : super._();
  @override
  ReadyMixedConcreteOpenInspection rebuild(
          void Function(ReadyMixedConcreteOpenInspectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadyMixedConcreteOpenInspectionBuilder toBuilder() =>
      ReadyMixedConcreteOpenInspectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadyMixedConcreteOpenInspection &&
        id == other.id &&
        status == other.status &&
        conversationId == other.conversationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadyMixedConcreteOpenInspection')
          ..add('id', id)
          ..add('status', status)
          ..add('conversationId', conversationId))
        .toString();
  }
}

class ReadyMixedConcreteOpenInspectionBuilder
    implements
        Builder<ReadyMixedConcreteOpenInspection,
            ReadyMixedConcreteOpenInspectionBuilder> {
  _$ReadyMixedConcreteOpenInspection? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ReadyMixedConcreteOpenInspectionStatusEnum? _status;
  ReadyMixedConcreteOpenInspectionStatusEnum? get status => _$this._status;
  set status(ReadyMixedConcreteOpenInspectionStatusEnum? status) =>
      _$this._status = status;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  ReadyMixedConcreteOpenInspectionBuilder() {
    ReadyMixedConcreteOpenInspection._defaults(this);
  }

  ReadyMixedConcreteOpenInspectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _conversationId = $v.conversationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadyMixedConcreteOpenInspection other) {
    _$v = other as _$ReadyMixedConcreteOpenInspection;
  }

  @override
  void update(void Function(ReadyMixedConcreteOpenInspectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadyMixedConcreteOpenInspection build() => _build();

  _$ReadyMixedConcreteOpenInspection _build() {
    final _$result = _$v ??
        _$ReadyMixedConcreteOpenInspection._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ReadyMixedConcreteOpenInspection', 'id'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ReadyMixedConcreteOpenInspection', 'status'),
          conversationId: BuiltValueNullFieldError.checkNotNull(conversationId,
              r'ReadyMixedConcreteOpenInspection', 'conversationId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
