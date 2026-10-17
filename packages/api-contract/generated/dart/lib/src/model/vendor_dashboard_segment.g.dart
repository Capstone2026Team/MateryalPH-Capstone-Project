// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_segment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardSegment extends VendorDashboardSegment {
  @override
  final int id;
  @override
  final String label;
  @override
  final int size;
  @override
  final num averageOrders;
  @override
  final num averageBuyers;
  @override
  final int? averageValueCentavos;
  @override
  final BuiltList<String> examples;

  factory _$VendorDashboardSegment(
          [void Function(VendorDashboardSegmentBuilder)? updates]) =>
      (VendorDashboardSegmentBuilder()..update(updates))._build();

  _$VendorDashboardSegment._(
      {required this.id,
      required this.label,
      required this.size,
      required this.averageOrders,
      required this.averageBuyers,
      this.averageValueCentavos,
      required this.examples})
      : super._();
  @override
  VendorDashboardSegment rebuild(
          void Function(VendorDashboardSegmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardSegmentBuilder toBuilder() =>
      VendorDashboardSegmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardSegment &&
        id == other.id &&
        label == other.label &&
        size == other.size &&
        averageOrders == other.averageOrders &&
        averageBuyers == other.averageBuyers &&
        averageValueCentavos == other.averageValueCentavos &&
        examples == other.examples;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, averageOrders.hashCode);
    _$hash = $jc(_$hash, averageBuyers.hashCode);
    _$hash = $jc(_$hash, averageValueCentavos.hashCode);
    _$hash = $jc(_$hash, examples.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardSegment')
          ..add('id', id)
          ..add('label', label)
          ..add('size', size)
          ..add('averageOrders', averageOrders)
          ..add('averageBuyers', averageBuyers)
          ..add('averageValueCentavos', averageValueCentavos)
          ..add('examples', examples))
        .toString();
  }
}

class VendorDashboardSegmentBuilder
    implements Builder<VendorDashboardSegment, VendorDashboardSegmentBuilder> {
  _$VendorDashboardSegment? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  num? _averageOrders;
  num? get averageOrders => _$this._averageOrders;
  set averageOrders(num? averageOrders) =>
      _$this._averageOrders = averageOrders;

  num? _averageBuyers;
  num? get averageBuyers => _$this._averageBuyers;
  set averageBuyers(num? averageBuyers) =>
      _$this._averageBuyers = averageBuyers;

  int? _averageValueCentavos;
  int? get averageValueCentavos => _$this._averageValueCentavos;
  set averageValueCentavos(int? averageValueCentavos) =>
      _$this._averageValueCentavos = averageValueCentavos;

  ListBuilder<String>? _examples;
  ListBuilder<String> get examples =>
      _$this._examples ??= ListBuilder<String>();
  set examples(ListBuilder<String>? examples) => _$this._examples = examples;

  VendorDashboardSegmentBuilder() {
    VendorDashboardSegment._defaults(this);
  }

  VendorDashboardSegmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _size = $v.size;
      _averageOrders = $v.averageOrders;
      _averageBuyers = $v.averageBuyers;
      _averageValueCentavos = $v.averageValueCentavos;
      _examples = $v.examples.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardSegment other) {
    _$v = other as _$VendorDashboardSegment;
  }

  @override
  void update(void Function(VendorDashboardSegmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardSegment build() => _build();

  _$VendorDashboardSegment _build() {
    _$VendorDashboardSegment _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardSegment._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'VendorDashboardSegment', 'id'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'VendorDashboardSegment', 'label'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'VendorDashboardSegment', 'size'),
            averageOrders: BuiltValueNullFieldError.checkNotNull(
                averageOrders, r'VendorDashboardSegment', 'averageOrders'),
            averageBuyers: BuiltValueNullFieldError.checkNotNull(
                averageBuyers, r'VendorDashboardSegment', 'averageBuyers'),
            averageValueCentavos: averageValueCentavos,
            examples: examples.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'examples';
        examples.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardSegment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
