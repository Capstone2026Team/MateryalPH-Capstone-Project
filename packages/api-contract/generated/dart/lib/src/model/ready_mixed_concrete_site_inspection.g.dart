// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready_mixed_concrete_site_inspection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReadyMixedConcreteSiteInspection
    extends ReadyMixedConcreteSiteInspection {
  @override
  final bool free;
  @override
  final bool available;
  @override
  final ReadyMixedConcreteOpenInspection? openRequest;

  factory _$ReadyMixedConcreteSiteInspection(
          [void Function(ReadyMixedConcreteSiteInspectionBuilder)? updates]) =>
      (ReadyMixedConcreteSiteInspectionBuilder()..update(updates))._build();

  _$ReadyMixedConcreteSiteInspection._(
      {required this.free, required this.available, this.openRequest})
      : super._();
  @override
  ReadyMixedConcreteSiteInspection rebuild(
          void Function(ReadyMixedConcreteSiteInspectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadyMixedConcreteSiteInspectionBuilder toBuilder() =>
      ReadyMixedConcreteSiteInspectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadyMixedConcreteSiteInspection &&
        free == other.free &&
        available == other.available &&
        openRequest == other.openRequest;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, free.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, openRequest.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadyMixedConcreteSiteInspection')
          ..add('free', free)
          ..add('available', available)
          ..add('openRequest', openRequest))
        .toString();
  }
}

class ReadyMixedConcreteSiteInspectionBuilder
    implements
        Builder<ReadyMixedConcreteSiteInspection,
            ReadyMixedConcreteSiteInspectionBuilder> {
  _$ReadyMixedConcreteSiteInspection? _$v;

  bool? _free;
  bool? get free => _$this._free;
  set free(bool? free) => _$this._free = free;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  ReadyMixedConcreteOpenInspectionBuilder? _openRequest;
  ReadyMixedConcreteOpenInspectionBuilder get openRequest =>
      _$this._openRequest ??= ReadyMixedConcreteOpenInspectionBuilder();
  set openRequest(ReadyMixedConcreteOpenInspectionBuilder? openRequest) =>
      _$this._openRequest = openRequest;

  ReadyMixedConcreteSiteInspectionBuilder() {
    ReadyMixedConcreteSiteInspection._defaults(this);
  }

  ReadyMixedConcreteSiteInspectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _free = $v.free;
      _available = $v.available;
      _openRequest = $v.openRequest?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadyMixedConcreteSiteInspection other) {
    _$v = other as _$ReadyMixedConcreteSiteInspection;
  }

  @override
  void update(void Function(ReadyMixedConcreteSiteInspectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadyMixedConcreteSiteInspection build() => _build();

  _$ReadyMixedConcreteSiteInspection _build() {
    _$ReadyMixedConcreteSiteInspection _$result;
    try {
      _$result = _$v ??
          _$ReadyMixedConcreteSiteInspection._(
            free: BuiltValueNullFieldError.checkNotNull(
                free, r'ReadyMixedConcreteSiteInspection', 'free'),
            available: BuiltValueNullFieldError.checkNotNull(
                available, r'ReadyMixedConcreteSiteInspection', 'available'),
            openRequest: _openRequest?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'openRequest';
        _openRequest?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReadyMixedConcreteSiteInspection', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
