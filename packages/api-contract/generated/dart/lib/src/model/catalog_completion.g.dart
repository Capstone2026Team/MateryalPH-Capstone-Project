// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_completion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogCompletion extends CatalogCompletion {
  @override
  final String key;
  @override
  final String label;
  @override
  final BuiltList<CatalogCompletionStep> steps;

  factory _$CatalogCompletion(
          [void Function(CatalogCompletionBuilder)? updates]) =>
      (CatalogCompletionBuilder()..update(updates))._build();

  _$CatalogCompletion._(
      {required this.key, required this.label, required this.steps})
      : super._();
  @override
  CatalogCompletion rebuild(void Function(CatalogCompletionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogCompletionBuilder toBuilder() =>
      CatalogCompletionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogCompletion &&
        key == other.key &&
        label == other.label &&
        steps == other.steps;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogCompletion')
          ..add('key', key)
          ..add('label', label)
          ..add('steps', steps))
        .toString();
  }
}

class CatalogCompletionBuilder
    implements Builder<CatalogCompletion, CatalogCompletionBuilder> {
  _$CatalogCompletion? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<CatalogCompletionStep>? _steps;
  ListBuilder<CatalogCompletionStep> get steps =>
      _$this._steps ??= ListBuilder<CatalogCompletionStep>();
  set steps(ListBuilder<CatalogCompletionStep>? steps) => _$this._steps = steps;

  CatalogCompletionBuilder() {
    CatalogCompletion._defaults(this);
  }

  CatalogCompletionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _steps = $v.steps.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogCompletion other) {
    _$v = other as _$CatalogCompletion;
  }

  @override
  void update(void Function(CatalogCompletionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogCompletion build() => _build();

  _$CatalogCompletion _build() {
    _$CatalogCompletion _$result;
    try {
      _$result = _$v ??
          _$CatalogCompletion._(
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'CatalogCompletion', 'key'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'CatalogCompletion', 'label'),
            steps: steps.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogCompletion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
