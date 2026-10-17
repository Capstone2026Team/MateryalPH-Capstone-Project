// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_workspace_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryWorkspacePage extends DeliveryWorkspacePage {
  @override
  final BuiltList<OrderDetail> data;
  @override
  final DeliveryWorkspacePageMeta meta;
  @override
  final BuiltList<ApiError>? errors;

  factory _$DeliveryWorkspacePage(
          [void Function(DeliveryWorkspacePageBuilder)? updates]) =>
      (DeliveryWorkspacePageBuilder()..update(updates))._build();

  _$DeliveryWorkspacePage._(
      {required this.data, required this.meta, this.errors})
      : super._();
  @override
  DeliveryWorkspacePage rebuild(
          void Function(DeliveryWorkspacePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryWorkspacePageBuilder toBuilder() =>
      DeliveryWorkspacePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryWorkspacePage &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryWorkspacePage')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DeliveryWorkspacePageBuilder
    implements Builder<DeliveryWorkspacePage, DeliveryWorkspacePageBuilder> {
  _$DeliveryWorkspacePage? _$v;

  ListBuilder<OrderDetail>? _data;
  ListBuilder<OrderDetail> get data =>
      _$this._data ??= ListBuilder<OrderDetail>();
  set data(ListBuilder<OrderDetail>? data) => _$this._data = data;

  DeliveryWorkspacePageMetaBuilder? _meta;
  DeliveryWorkspacePageMetaBuilder get meta =>
      _$this._meta ??= DeliveryWorkspacePageMetaBuilder();
  set meta(DeliveryWorkspacePageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DeliveryWorkspacePageBuilder() {
    DeliveryWorkspacePage._defaults(this);
  }

  DeliveryWorkspacePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryWorkspacePage other) {
    _$v = other as _$DeliveryWorkspacePage;
  }

  @override
  void update(void Function(DeliveryWorkspacePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryWorkspacePage build() => _build();

  _$DeliveryWorkspacePage _build() {
    _$DeliveryWorkspacePage _$result;
    try {
      _$result = _$v ??
          _$DeliveryWorkspacePage._(
            data: data.build(),
            meta: meta.build(),
            errors: _errors?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        _errors?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryWorkspacePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
