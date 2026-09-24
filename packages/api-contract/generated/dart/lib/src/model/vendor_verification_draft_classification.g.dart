// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_verification_draft_classification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorVerificationDraftClassification
    extends VendorVerificationDraftClassification {
  @override
  final String? supplierType;
  @override
  final BuiltList<String>? niches;
  @override
  final String? customLabel;
  @override
  final BuiltSet<String>? customLabels;

  factory _$VendorVerificationDraftClassification(
          [void Function(VendorVerificationDraftClassificationBuilder)?
              updates]) =>
      (VendorVerificationDraftClassificationBuilder()..update(updates))
          ._build();

  _$VendorVerificationDraftClassification._(
      {this.supplierType, this.niches, this.customLabel, this.customLabels})
      : super._();
  @override
  VendorVerificationDraftClassification rebuild(
          void Function(VendorVerificationDraftClassificationBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVerificationDraftClassificationBuilder toBuilder() =>
      VendorVerificationDraftClassificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVerificationDraftClassification &&
        supplierType == other.supplierType &&
        niches == other.niches &&
        customLabel == other.customLabel &&
        customLabels == other.customLabels;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, supplierType.hashCode);
    _$hash = $jc(_$hash, niches.hashCode);
    _$hash = $jc(_$hash, customLabel.hashCode);
    _$hash = $jc(_$hash, customLabels.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorVerificationDraftClassification')
          ..add('supplierType', supplierType)
          ..add('niches', niches)
          ..add('customLabel', customLabel)
          ..add('customLabels', customLabels))
        .toString();
  }
}

class VendorVerificationDraftClassificationBuilder
    implements
        Builder<VendorVerificationDraftClassification,
            VendorVerificationDraftClassificationBuilder> {
  _$VendorVerificationDraftClassification? _$v;

  String? _supplierType;
  String? get supplierType => _$this._supplierType;
  set supplierType(String? supplierType) => _$this._supplierType = supplierType;

  ListBuilder<String>? _niches;
  ListBuilder<String> get niches => _$this._niches ??= ListBuilder<String>();
  set niches(ListBuilder<String>? niches) => _$this._niches = niches;

  String? _customLabel;
  String? get customLabel => _$this._customLabel;
  set customLabel(String? customLabel) => _$this._customLabel = customLabel;

  SetBuilder<String>? _customLabels;
  SetBuilder<String> get customLabels =>
      _$this._customLabels ??= SetBuilder<String>();
  set customLabels(SetBuilder<String>? customLabels) =>
      _$this._customLabels = customLabels;

  VendorVerificationDraftClassificationBuilder() {
    VendorVerificationDraftClassification._defaults(this);
  }

  VendorVerificationDraftClassificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _supplierType = $v.supplierType;
      _niches = $v.niches?.toBuilder();
      _customLabel = $v.customLabel;
      _customLabels = $v.customLabels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVerificationDraftClassification other) {
    _$v = other as _$VendorVerificationDraftClassification;
  }

  @override
  void update(
      void Function(VendorVerificationDraftClassificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVerificationDraftClassification build() => _build();

  _$VendorVerificationDraftClassification _build() {
    _$VendorVerificationDraftClassification _$result;
    try {
      _$result = _$v ??
          _$VendorVerificationDraftClassification._(
            supplierType: supplierType,
            niches: _niches?.build(),
            customLabel: customLabel,
            customLabels: _customLabels?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'niches';
        _niches?.build();

        _$failedField = 'customLabels';
        _customLabels?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorVerificationDraftClassification',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
