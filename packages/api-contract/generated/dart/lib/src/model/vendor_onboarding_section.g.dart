// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_onboarding_section.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOnboardingSection extends VendorOnboardingSection {
  @override
  final String key;
  @override
  final String label;
  @override
  final String status;
  @override
  final int complete;
  @override
  final int total;
  @override
  final BuiltMap<String, JsonObject?> progress;
  @override
  final BuiltList<VendorOnboardingStep> steps;

  factory _$VendorOnboardingSection(
          [void Function(VendorOnboardingSectionBuilder)? updates]) =>
      (VendorOnboardingSectionBuilder()..update(updates))._build();

  _$VendorOnboardingSection._(
      {required this.key,
      required this.label,
      required this.status,
      required this.complete,
      required this.total,
      required this.progress,
      required this.steps})
      : super._();
  @override
  VendorOnboardingSection rebuild(
          void Function(VendorOnboardingSectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOnboardingSectionBuilder toBuilder() =>
      VendorOnboardingSectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOnboardingSection &&
        key == other.key &&
        label == other.label &&
        status == other.status &&
        complete == other.complete &&
        total == other.total &&
        progress == other.progress &&
        steps == other.steps;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, complete.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, progress.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOnboardingSection')
          ..add('key', key)
          ..add('label', label)
          ..add('status', status)
          ..add('complete', complete)
          ..add('total', total)
          ..add('progress', progress)
          ..add('steps', steps))
        .toString();
  }
}

class VendorOnboardingSectionBuilder
    implements
        Builder<VendorOnboardingSection, VendorOnboardingSectionBuilder> {
  _$VendorOnboardingSection? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  int? _complete;
  int? get complete => _$this._complete;
  set complete(int? complete) => _$this._complete = complete;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  MapBuilder<String, JsonObject?>? _progress;
  MapBuilder<String, JsonObject?> get progress =>
      _$this._progress ??= MapBuilder<String, JsonObject?>();
  set progress(MapBuilder<String, JsonObject?>? progress) =>
      _$this._progress = progress;

  ListBuilder<VendorOnboardingStep>? _steps;
  ListBuilder<VendorOnboardingStep> get steps =>
      _$this._steps ??= ListBuilder<VendorOnboardingStep>();
  set steps(ListBuilder<VendorOnboardingStep>? steps) => _$this._steps = steps;

  VendorOnboardingSectionBuilder() {
    VendorOnboardingSection._defaults(this);
  }

  VendorOnboardingSectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _status = $v.status;
      _complete = $v.complete;
      _total = $v.total;
      _progress = $v.progress.toBuilder();
      _steps = $v.steps.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOnboardingSection other) {
    _$v = other as _$VendorOnboardingSection;
  }

  @override
  void update(void Function(VendorOnboardingSectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOnboardingSection build() => _build();

  _$VendorOnboardingSection _build() {
    _$VendorOnboardingSection _$result;
    try {
      _$result = _$v ??
          _$VendorOnboardingSection._(
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'VendorOnboardingSection', 'key'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'VendorOnboardingSection', 'label'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'VendorOnboardingSection', 'status'),
            complete: BuiltValueNullFieldError.checkNotNull(
                complete, r'VendorOnboardingSection', 'complete'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'VendorOnboardingSection', 'total'),
            progress: progress.build(),
            steps: steps.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'progress';
        progress.build();
        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorOnboardingSection', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
