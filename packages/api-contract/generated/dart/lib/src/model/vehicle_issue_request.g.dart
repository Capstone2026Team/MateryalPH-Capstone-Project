// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_issue_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VehicleIssueRequestCategoryEnum
    _$vehicleIssueRequestCategoryEnum_BREAKDOWN =
    const VehicleIssueRequestCategoryEnum._('BREAKDOWN');
const VehicleIssueRequestCategoryEnum
    _$vehicleIssueRequestCategoryEnum_CAPACITY_SHORTFALL =
    const VehicleIssueRequestCategoryEnum._('CAPACITY_SHORTFALL');
const VehicleIssueRequestCategoryEnum
    _$vehicleIssueRequestCategoryEnum_ACCESS_BLOCKED =
    const VehicleIssueRequestCategoryEnum._('ACCESS_BLOCKED');
const VehicleIssueRequestCategoryEnum _$vehicleIssueRequestCategoryEnum_DELAY =
    const VehicleIssueRequestCategoryEnum._('DELAY');
const VehicleIssueRequestCategoryEnum _$vehicleIssueRequestCategoryEnum_OTHER =
    const VehicleIssueRequestCategoryEnum._('OTHER');

VehicleIssueRequestCategoryEnum _$vehicleIssueRequestCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'BREAKDOWN':
      return _$vehicleIssueRequestCategoryEnum_BREAKDOWN;
    case 'CAPACITY_SHORTFALL':
      return _$vehicleIssueRequestCategoryEnum_CAPACITY_SHORTFALL;
    case 'ACCESS_BLOCKED':
      return _$vehicleIssueRequestCategoryEnum_ACCESS_BLOCKED;
    case 'DELAY':
      return _$vehicleIssueRequestCategoryEnum_DELAY;
    case 'OTHER':
      return _$vehicleIssueRequestCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VehicleIssueRequestCategoryEnum>
    _$vehicleIssueRequestCategoryEnumValues = BuiltSet<
        VehicleIssueRequestCategoryEnum>(const <VehicleIssueRequestCategoryEnum>[
  _$vehicleIssueRequestCategoryEnum_BREAKDOWN,
  _$vehicleIssueRequestCategoryEnum_CAPACITY_SHORTFALL,
  _$vehicleIssueRequestCategoryEnum_ACCESS_BLOCKED,
  _$vehicleIssueRequestCategoryEnum_DELAY,
  _$vehicleIssueRequestCategoryEnum_OTHER,
]);

Serializer<VehicleIssueRequestCategoryEnum>
    _$vehicleIssueRequestCategoryEnumSerializer =
    _$VehicleIssueRequestCategoryEnumSerializer();

class _$VehicleIssueRequestCategoryEnumSerializer
    implements PrimitiveSerializer<VehicleIssueRequestCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BREAKDOWN': 'BREAKDOWN',
    'CAPACITY_SHORTFALL': 'CAPACITY_SHORTFALL',
    'ACCESS_BLOCKED': 'ACCESS_BLOCKED',
    'DELAY': 'DELAY',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BREAKDOWN': 'BREAKDOWN',
    'CAPACITY_SHORTFALL': 'CAPACITY_SHORTFALL',
    'ACCESS_BLOCKED': 'ACCESS_BLOCKED',
    'DELAY': 'DELAY',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[VehicleIssueRequestCategoryEnum];
  @override
  final String wireName = 'VehicleIssueRequestCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, VehicleIssueRequestCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VehicleIssueRequestCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VehicleIssueRequestCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VehicleIssueRequest extends VehicleIssueRequest {
  @override
  final VehicleIssueRequestCategoryEnum category;
  @override
  final String description;

  factory _$VehicleIssueRequest(
          [void Function(VehicleIssueRequestBuilder)? updates]) =>
      (VehicleIssueRequestBuilder()..update(updates))._build();

  _$VehicleIssueRequest._({required this.category, required this.description})
      : super._();
  @override
  VehicleIssueRequest rebuild(
          void Function(VehicleIssueRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleIssueRequestBuilder toBuilder() =>
      VehicleIssueRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleIssueRequest &&
        category == other.category &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VehicleIssueRequest')
          ..add('category', category)
          ..add('description', description))
        .toString();
  }
}

class VehicleIssueRequestBuilder
    implements Builder<VehicleIssueRequest, VehicleIssueRequestBuilder> {
  _$VehicleIssueRequest? _$v;

  VehicleIssueRequestCategoryEnum? _category;
  VehicleIssueRequestCategoryEnum? get category => _$this._category;
  set category(VehicleIssueRequestCategoryEnum? category) =>
      _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  VehicleIssueRequestBuilder() {
    VehicleIssueRequest._defaults(this);
  }

  VehicleIssueRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VehicleIssueRequest other) {
    _$v = other as _$VehicleIssueRequest;
  }

  @override
  void update(void Function(VehicleIssueRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleIssueRequest build() => _build();

  _$VehicleIssueRequest _build() {
    final _$result = _$v ??
        _$VehicleIssueRequest._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'VehicleIssueRequest', 'category'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'VehicleIssueRequest', 'description'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
