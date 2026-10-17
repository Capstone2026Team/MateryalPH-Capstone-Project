// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_attribute_label.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingAttributeLabel extends ListingAttributeLabel {
  @override
  final String code;
  @override
  final String label;
  @override
  final String? unitCode;

  factory _$ListingAttributeLabel(
          [void Function(ListingAttributeLabelBuilder)? updates]) =>
      (ListingAttributeLabelBuilder()..update(updates))._build();

  _$ListingAttributeLabel._(
      {required this.code, required this.label, this.unitCode})
      : super._();
  @override
  ListingAttributeLabel rebuild(
          void Function(ListingAttributeLabelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingAttributeLabelBuilder toBuilder() =>
      ListingAttributeLabelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingAttributeLabel &&
        code == other.code &&
        label == other.label &&
        unitCode == other.unitCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingAttributeLabel')
          ..add('code', code)
          ..add('label', label)
          ..add('unitCode', unitCode))
        .toString();
  }
}

class ListingAttributeLabelBuilder
    implements Builder<ListingAttributeLabel, ListingAttributeLabelBuilder> {
  _$ListingAttributeLabel? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  ListingAttributeLabelBuilder() {
    ListingAttributeLabel._defaults(this);
  }

  ListingAttributeLabelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _unitCode = $v.unitCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingAttributeLabel other) {
    _$v = other as _$ListingAttributeLabel;
  }

  @override
  void update(void Function(ListingAttributeLabelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingAttributeLabel build() => _build();

  _$ListingAttributeLabel _build() {
    final _$result = _$v ??
        _$ListingAttributeLabel._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ListingAttributeLabel', 'code'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ListingAttributeLabel', 'label'),
          unitCode: unitCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
