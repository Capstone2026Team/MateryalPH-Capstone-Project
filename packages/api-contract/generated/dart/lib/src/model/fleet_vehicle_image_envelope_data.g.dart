// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_image_envelope_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FleetVehicleImageEnvelopeDataStatusEnum
    _$fleetVehicleImageEnvelopeDataStatusEnum_READY =
    const FleetVehicleImageEnvelopeDataStatusEnum._('READY');

FleetVehicleImageEnvelopeDataStatusEnum
    _$fleetVehicleImageEnvelopeDataStatusEnumValueOf(String name) {
  switch (name) {
    case 'READY':
      return _$fleetVehicleImageEnvelopeDataStatusEnum_READY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FleetVehicleImageEnvelopeDataStatusEnum>
    _$fleetVehicleImageEnvelopeDataStatusEnumValues = BuiltSet<
        FleetVehicleImageEnvelopeDataStatusEnum>(const <FleetVehicleImageEnvelopeDataStatusEnum>[
  _$fleetVehicleImageEnvelopeDataStatusEnum_READY,
]);

Serializer<FleetVehicleImageEnvelopeDataStatusEnum>
    _$fleetVehicleImageEnvelopeDataStatusEnumSerializer =
    _$FleetVehicleImageEnvelopeDataStatusEnumSerializer();

class _$FleetVehicleImageEnvelopeDataStatusEnumSerializer
    implements PrimitiveSerializer<FleetVehicleImageEnvelopeDataStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'READY': 'READY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'READY': 'READY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FleetVehicleImageEnvelopeDataStatusEnum
  ];
  @override
  final String wireName = 'FleetVehicleImageEnvelopeDataStatusEnum';

  @override
  Object serialize(Serializers serializers,
          FleetVehicleImageEnvelopeDataStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FleetVehicleImageEnvelopeDataStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FleetVehicleImageEnvelopeDataStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FleetVehicleImageEnvelopeData extends FleetVehicleImageEnvelopeData {
  @override
  final String fileId;
  @override
  final FleetVehicleImageEnvelopeDataStatusEnum status;
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$FleetVehicleImageEnvelopeData(
          [void Function(FleetVehicleImageEnvelopeDataBuilder)? updates]) =>
      (FleetVehicleImageEnvelopeDataBuilder()..update(updates))._build();

  _$FleetVehicleImageEnvelopeData._(
      {required this.fileId,
      required this.status,
      required this.url,
      required this.expiresAt})
      : super._();
  @override
  FleetVehicleImageEnvelopeData rebuild(
          void Function(FleetVehicleImageEnvelopeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleImageEnvelopeDataBuilder toBuilder() =>
      FleetVehicleImageEnvelopeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleImageEnvelopeData &&
        fileId == other.fileId &&
        status == other.status &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicleImageEnvelopeData')
          ..add('fileId', fileId)
          ..add('status', status)
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class FleetVehicleImageEnvelopeDataBuilder
    implements
        Builder<FleetVehicleImageEnvelopeData,
            FleetVehicleImageEnvelopeDataBuilder> {
  _$FleetVehicleImageEnvelopeData? _$v;

  String? _fileId;
  String? get fileId => _$this._fileId;
  set fileId(String? fileId) => _$this._fileId = fileId;

  FleetVehicleImageEnvelopeDataStatusEnum? _status;
  FleetVehicleImageEnvelopeDataStatusEnum? get status => _$this._status;
  set status(FleetVehicleImageEnvelopeDataStatusEnum? status) =>
      _$this._status = status;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  FleetVehicleImageEnvelopeDataBuilder() {
    FleetVehicleImageEnvelopeData._defaults(this);
  }

  FleetVehicleImageEnvelopeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileId = $v.fileId;
      _status = $v.status;
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicleImageEnvelopeData other) {
    _$v = other as _$FleetVehicleImageEnvelopeData;
  }

  @override
  void update(void Function(FleetVehicleImageEnvelopeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleImageEnvelopeData build() => _build();

  _$FleetVehicleImageEnvelopeData _build() {
    final _$result = _$v ??
        _$FleetVehicleImageEnvelopeData._(
          fileId: BuiltValueNullFieldError.checkNotNull(
              fileId, r'FleetVehicleImageEnvelopeData', 'fileId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FleetVehicleImageEnvelopeData', 'status'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'FleetVehicleImageEnvelopeData', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'FleetVehicleImageEnvelopeData', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
