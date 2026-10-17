// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_export_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeExportRequestGroupEnum _$disputeExportRequestGroupEnum_ALL =
    const DisputeExportRequestGroupEnum._('ALL');
const DisputeExportRequestGroupEnum _$disputeExportRequestGroupEnum_ACTIVE =
    const DisputeExportRequestGroupEnum._('ACTIVE');
const DisputeExportRequestGroupEnum
    _$disputeExportRequestGroupEnum_NEEDS_RESPONSE =
    const DisputeExportRequestGroupEnum._('NEEDS_RESPONSE');
const DisputeExportRequestGroupEnum
    _$disputeExportRequestGroupEnum_ADMIN_REVIEW =
    const DisputeExportRequestGroupEnum._('ADMIN_REVIEW');
const DisputeExportRequestGroupEnum _$disputeExportRequestGroupEnum_DECIDED =
    const DisputeExportRequestGroupEnum._('DECIDED');
const DisputeExportRequestGroupEnum _$disputeExportRequestGroupEnum_CONCLUDED =
    const DisputeExportRequestGroupEnum._('CONCLUDED');

DisputeExportRequestGroupEnum _$disputeExportRequestGroupEnumValueOf(
    String name) {
  switch (name) {
    case 'ALL':
      return _$disputeExportRequestGroupEnum_ALL;
    case 'ACTIVE':
      return _$disputeExportRequestGroupEnum_ACTIVE;
    case 'NEEDS_RESPONSE':
      return _$disputeExportRequestGroupEnum_NEEDS_RESPONSE;
    case 'ADMIN_REVIEW':
      return _$disputeExportRequestGroupEnum_ADMIN_REVIEW;
    case 'DECIDED':
      return _$disputeExportRequestGroupEnum_DECIDED;
    case 'CONCLUDED':
      return _$disputeExportRequestGroupEnum_CONCLUDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeExportRequestGroupEnum>
    _$disputeExportRequestGroupEnumValues = BuiltSet<
        DisputeExportRequestGroupEnum>(const <DisputeExportRequestGroupEnum>[
  _$disputeExportRequestGroupEnum_ALL,
  _$disputeExportRequestGroupEnum_ACTIVE,
  _$disputeExportRequestGroupEnum_NEEDS_RESPONSE,
  _$disputeExportRequestGroupEnum_ADMIN_REVIEW,
  _$disputeExportRequestGroupEnum_DECIDED,
  _$disputeExportRequestGroupEnum_CONCLUDED,
]);

Serializer<DisputeExportRequestGroupEnum>
    _$disputeExportRequestGroupEnumSerializer =
    _$DisputeExportRequestGroupEnumSerializer();

class _$DisputeExportRequestGroupEnumSerializer
    implements PrimitiveSerializer<DisputeExportRequestGroupEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ALL': 'ALL',
    'ACTIVE': 'ACTIVE',
    'NEEDS_RESPONSE': 'NEEDS_RESPONSE',
    'ADMIN_REVIEW': 'ADMIN_REVIEW',
    'DECIDED': 'DECIDED',
    'CONCLUDED': 'CONCLUDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ALL': 'ALL',
    'ACTIVE': 'ACTIVE',
    'NEEDS_RESPONSE': 'NEEDS_RESPONSE',
    'ADMIN_REVIEW': 'ADMIN_REVIEW',
    'DECIDED': 'DECIDED',
    'CONCLUDED': 'CONCLUDED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeExportRequestGroupEnum];
  @override
  final String wireName = 'DisputeExportRequestGroupEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeExportRequestGroupEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeExportRequestGroupEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeExportRequestGroupEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeExportRequest extends DisputeExportRequest {
  @override
  final DisputeExportRequestGroupEnum? group;

  factory _$DisputeExportRequest(
          [void Function(DisputeExportRequestBuilder)? updates]) =>
      (DisputeExportRequestBuilder()..update(updates))._build();

  _$DisputeExportRequest._({this.group}) : super._();
  @override
  DisputeExportRequest rebuild(
          void Function(DisputeExportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeExportRequestBuilder toBuilder() =>
      DisputeExportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeExportRequest && group == other.group;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeExportRequest')
          ..add('group', group))
        .toString();
  }
}

class DisputeExportRequestBuilder
    implements Builder<DisputeExportRequest, DisputeExportRequestBuilder> {
  _$DisputeExportRequest? _$v;

  DisputeExportRequestGroupEnum? _group;
  DisputeExportRequestGroupEnum? get group => _$this._group;
  set group(DisputeExportRequestGroupEnum? group) => _$this._group = group;

  DisputeExportRequestBuilder() {
    DisputeExportRequest._defaults(this);
  }

  DisputeExportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _group = $v.group;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeExportRequest other) {
    _$v = other as _$DisputeExportRequest;
  }

  @override
  void update(void Function(DisputeExportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeExportRequest build() => _build();

  _$DisputeExportRequest _build() {
    final _$result = _$v ??
        _$DisputeExportRequest._(
          group: group,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
