// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryAvailabilityStatusEnum
    _$directoryAvailabilityStatusEnum_AVAILABLE =
    const DirectoryAvailabilityStatusEnum._('AVAILABLE');
const DirectoryAvailabilityStatusEnum _$directoryAvailabilityStatusEnum_CACHED =
    const DirectoryAvailabilityStatusEnum._('CACHED');
const DirectoryAvailabilityStatusEnum
    _$directoryAvailabilityStatusEnum_UNAVAILABLE =
    const DirectoryAvailabilityStatusEnum._('UNAVAILABLE');
const DirectoryAvailabilityStatusEnum
    _$directoryAvailabilityStatusEnum_NOT_CONFIGURED =
    const DirectoryAvailabilityStatusEnum._('NOT_CONFIGURED');
const DirectoryAvailabilityStatusEnum
    _$directoryAvailabilityStatusEnum_FILTERED_OUT =
    const DirectoryAvailabilityStatusEnum._('FILTERED_OUT');
const DirectoryAvailabilityStatusEnum _$directoryAvailabilityStatusEnum_HIDDEN =
    const DirectoryAvailabilityStatusEnum._('HIDDEN');

DirectoryAvailabilityStatusEnum _$directoryAvailabilityStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$directoryAvailabilityStatusEnum_AVAILABLE;
    case 'CACHED':
      return _$directoryAvailabilityStatusEnum_CACHED;
    case 'UNAVAILABLE':
      return _$directoryAvailabilityStatusEnum_UNAVAILABLE;
    case 'NOT_CONFIGURED':
      return _$directoryAvailabilityStatusEnum_NOT_CONFIGURED;
    case 'FILTERED_OUT':
      return _$directoryAvailabilityStatusEnum_FILTERED_OUT;
    case 'HIDDEN':
      return _$directoryAvailabilityStatusEnum_HIDDEN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryAvailabilityStatusEnum>
    _$directoryAvailabilityStatusEnumValues = BuiltSet<
        DirectoryAvailabilityStatusEnum>(const <DirectoryAvailabilityStatusEnum>[
  _$directoryAvailabilityStatusEnum_AVAILABLE,
  _$directoryAvailabilityStatusEnum_CACHED,
  _$directoryAvailabilityStatusEnum_UNAVAILABLE,
  _$directoryAvailabilityStatusEnum_NOT_CONFIGURED,
  _$directoryAvailabilityStatusEnum_FILTERED_OUT,
  _$directoryAvailabilityStatusEnum_HIDDEN,
]);

Serializer<DirectoryAvailabilityStatusEnum>
    _$directoryAvailabilityStatusEnumSerializer =
    _$DirectoryAvailabilityStatusEnumSerializer();

class _$DirectoryAvailabilityStatusEnumSerializer
    implements PrimitiveSerializer<DirectoryAvailabilityStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'CACHED': 'CACHED',
    'UNAVAILABLE': 'UNAVAILABLE',
    'NOT_CONFIGURED': 'NOT_CONFIGURED',
    'FILTERED_OUT': 'FILTERED_OUT',
    'HIDDEN': 'HIDDEN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'CACHED': 'CACHED',
    'UNAVAILABLE': 'UNAVAILABLE',
    'NOT_CONFIGURED': 'NOT_CONFIGURED',
    'FILTERED_OUT': 'FILTERED_OUT',
    'HIDDEN': 'HIDDEN',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectoryAvailabilityStatusEnum];
  @override
  final String wireName = 'DirectoryAvailabilityStatusEnum';

  @override
  Object serialize(
          Serializers serializers, DirectoryAvailabilityStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryAvailabilityStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryAvailabilityStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryAvailability extends DirectoryAvailability {
  @override
  final DirectoryAvailabilityStatusEnum status;
  @override
  final DateTime? asOf;
  @override
  final ProviderAttribution attribution;
  @override
  final String coverageNote;

  factory _$DirectoryAvailability(
          [void Function(DirectoryAvailabilityBuilder)? updates]) =>
      (DirectoryAvailabilityBuilder()..update(updates))._build();

  _$DirectoryAvailability._(
      {required this.status,
      this.asOf,
      required this.attribution,
      required this.coverageNote})
      : super._();
  @override
  DirectoryAvailability rebuild(
          void Function(DirectoryAvailabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryAvailabilityBuilder toBuilder() =>
      DirectoryAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryAvailability &&
        status == other.status &&
        asOf == other.asOf &&
        attribution == other.attribution &&
        coverageNote == other.coverageNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, attribution.hashCode);
    _$hash = $jc(_$hash, coverageNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryAvailability')
          ..add('status', status)
          ..add('asOf', asOf)
          ..add('attribution', attribution)
          ..add('coverageNote', coverageNote))
        .toString();
  }
}

class DirectoryAvailabilityBuilder
    implements Builder<DirectoryAvailability, DirectoryAvailabilityBuilder> {
  _$DirectoryAvailability? _$v;

  DirectoryAvailabilityStatusEnum? _status;
  DirectoryAvailabilityStatusEnum? get status => _$this._status;
  set status(DirectoryAvailabilityStatusEnum? status) =>
      _$this._status = status;

  DateTime? _asOf;
  DateTime? get asOf => _$this._asOf;
  set asOf(DateTime? asOf) => _$this._asOf = asOf;

  ProviderAttributionBuilder? _attribution;
  ProviderAttributionBuilder get attribution =>
      _$this._attribution ??= ProviderAttributionBuilder();
  set attribution(ProviderAttributionBuilder? attribution) =>
      _$this._attribution = attribution;

  String? _coverageNote;
  String? get coverageNote => _$this._coverageNote;
  set coverageNote(String? coverageNote) => _$this._coverageNote = coverageNote;

  DirectoryAvailabilityBuilder() {
    DirectoryAvailability._defaults(this);
  }

  DirectoryAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _asOf = $v.asOf;
      _attribution = $v.attribution.toBuilder();
      _coverageNote = $v.coverageNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryAvailability other) {
    _$v = other as _$DirectoryAvailability;
  }

  @override
  void update(void Function(DirectoryAvailabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryAvailability build() => _build();

  _$DirectoryAvailability _build() {
    _$DirectoryAvailability _$result;
    try {
      _$result = _$v ??
          _$DirectoryAvailability._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DirectoryAvailability', 'status'),
            asOf: asOf,
            attribution: attribution.build(),
            coverageNote: BuiltValueNullFieldError.checkNotNull(
                coverageNote, r'DirectoryAvailability', 'coverageNote'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attribution';
        attribution.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectoryAvailability', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
