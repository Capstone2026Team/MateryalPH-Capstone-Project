// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_current_competitors.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorCurrentCompetitorsStatusEnum
    _$vendorCurrentCompetitorsStatusEnum_AVAILABLE =
    const VendorCurrentCompetitorsStatusEnum._('AVAILABLE');
const VendorCurrentCompetitorsStatusEnum
    _$vendorCurrentCompetitorsStatusEnum_SUPPRESSED =
    const VendorCurrentCompetitorsStatusEnum._('SUPPRESSED');

VendorCurrentCompetitorsStatusEnum _$vendorCurrentCompetitorsStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$vendorCurrentCompetitorsStatusEnum_AVAILABLE;
    case 'SUPPRESSED':
      return _$vendorCurrentCompetitorsStatusEnum_SUPPRESSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorCurrentCompetitorsStatusEnum>
    _$vendorCurrentCompetitorsStatusEnumValues = BuiltSet<
        VendorCurrentCompetitorsStatusEnum>(const <VendorCurrentCompetitorsStatusEnum>[
  _$vendorCurrentCompetitorsStatusEnum_AVAILABLE,
  _$vendorCurrentCompetitorsStatusEnum_SUPPRESSED,
]);

Serializer<VendorCurrentCompetitorsStatusEnum>
    _$vendorCurrentCompetitorsStatusEnumSerializer =
    _$VendorCurrentCompetitorsStatusEnumSerializer();

class _$VendorCurrentCompetitorsStatusEnumSerializer
    implements PrimitiveSerializer<VendorCurrentCompetitorsStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'SUPPRESSED': 'SUPPRESSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'SUPPRESSED': 'SUPPRESSED',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorCurrentCompetitorsStatusEnum];
  @override
  final String wireName = 'VendorCurrentCompetitorsStatusEnum';

  @override
  Object serialize(
          Serializers serializers, VendorCurrentCompetitorsStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorCurrentCompetitorsStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorCurrentCompetitorsStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorCurrentCompetitors extends VendorCurrentCompetitors {
  @override
  final int? competitorCount;
  @override
  final VendorCurrentCompetitorsStatusEnum status;
  @override
  final String? label;

  factory _$VendorCurrentCompetitors(
          [void Function(VendorCurrentCompetitorsBuilder)? updates]) =>
      (VendorCurrentCompetitorsBuilder()..update(updates))._build();

  _$VendorCurrentCompetitors._(
      {this.competitorCount, required this.status, this.label})
      : super._();
  @override
  VendorCurrentCompetitors rebuild(
          void Function(VendorCurrentCompetitorsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCurrentCompetitorsBuilder toBuilder() =>
      VendorCurrentCompetitorsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCurrentCompetitors &&
        competitorCount == other.competitorCount &&
        status == other.status &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, competitorCount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCurrentCompetitors')
          ..add('competitorCount', competitorCount)
          ..add('status', status)
          ..add('label', label))
        .toString();
  }
}

class VendorCurrentCompetitorsBuilder
    implements
        Builder<VendorCurrentCompetitors, VendorCurrentCompetitorsBuilder> {
  _$VendorCurrentCompetitors? _$v;

  int? _competitorCount;
  int? get competitorCount => _$this._competitorCount;
  set competitorCount(int? competitorCount) =>
      _$this._competitorCount = competitorCount;

  VendorCurrentCompetitorsStatusEnum? _status;
  VendorCurrentCompetitorsStatusEnum? get status => _$this._status;
  set status(VendorCurrentCompetitorsStatusEnum? status) =>
      _$this._status = status;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  VendorCurrentCompetitorsBuilder() {
    VendorCurrentCompetitors._defaults(this);
  }

  VendorCurrentCompetitorsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _competitorCount = $v.competitorCount;
      _status = $v.status;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCurrentCompetitors other) {
    _$v = other as _$VendorCurrentCompetitors;
  }

  @override
  void update(void Function(VendorCurrentCompetitorsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCurrentCompetitors build() => _build();

  _$VendorCurrentCompetitors _build() {
    final _$result = _$v ??
        _$VendorCurrentCompetitors._(
          competitorCount: competitorCount,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorCurrentCompetitors', 'status'),
          label: label,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
