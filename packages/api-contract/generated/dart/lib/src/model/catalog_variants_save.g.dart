// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_variants_save.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogVariantsSave extends CatalogVariantsSave {
  @override
  final int lockVersion;
  @override
  final BuiltList<CatalogVariantInput> variants;

  factory _$CatalogVariantsSave(
          [void Function(CatalogVariantsSaveBuilder)? updates]) =>
      (CatalogVariantsSaveBuilder()..update(updates))._build();

  _$CatalogVariantsSave._({required this.lockVersion, required this.variants})
      : super._();
  @override
  CatalogVariantsSave rebuild(
          void Function(CatalogVariantsSaveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogVariantsSaveBuilder toBuilder() =>
      CatalogVariantsSaveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogVariantsSave &&
        lockVersion == other.lockVersion &&
        variants == other.variants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogVariantsSave')
          ..add('lockVersion', lockVersion)
          ..add('variants', variants))
        .toString();
  }
}

class CatalogVariantsSaveBuilder
    implements Builder<CatalogVariantsSave, CatalogVariantsSaveBuilder> {
  _$CatalogVariantsSave? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ListBuilder<CatalogVariantInput>? _variants;
  ListBuilder<CatalogVariantInput> get variants =>
      _$this._variants ??= ListBuilder<CatalogVariantInput>();
  set variants(ListBuilder<CatalogVariantInput>? variants) =>
      _$this._variants = variants;

  CatalogVariantsSaveBuilder() {
    CatalogVariantsSave._defaults(this);
  }

  CatalogVariantsSaveBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _variants = $v.variants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogVariantsSave other) {
    _$v = other as _$CatalogVariantsSave;
  }

  @override
  void update(void Function(CatalogVariantsSaveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogVariantsSave build() => _build();

  _$CatalogVariantsSave _build() {
    _$CatalogVariantsSave _$result;
    try {
      _$result = _$v ??
          _$CatalogVariantsSave._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'CatalogVariantsSave', 'lockVersion'),
            variants: variants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'variants';
        variants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogVariantsSave', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
