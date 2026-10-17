// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_correction_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsCorrectionRequest extends AnalyticsCorrectionRequest {
  @override
  final BuiltList<String> excludedObservationIds;
  @override
  final String reason;

  factory _$AnalyticsCorrectionRequest(
          [void Function(AnalyticsCorrectionRequestBuilder)? updates]) =>
      (AnalyticsCorrectionRequestBuilder()..update(updates))._build();

  _$AnalyticsCorrectionRequest._(
      {required this.excludedObservationIds, required this.reason})
      : super._();
  @override
  AnalyticsCorrectionRequest rebuild(
          void Function(AnalyticsCorrectionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsCorrectionRequestBuilder toBuilder() =>
      AnalyticsCorrectionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsCorrectionRequest &&
        excludedObservationIds == other.excludedObservationIds &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, excludedObservationIds.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsCorrectionRequest')
          ..add('excludedObservationIds', excludedObservationIds)
          ..add('reason', reason))
        .toString();
  }
}

class AnalyticsCorrectionRequestBuilder
    implements
        Builder<AnalyticsCorrectionRequest, AnalyticsCorrectionRequestBuilder> {
  _$AnalyticsCorrectionRequest? _$v;

  ListBuilder<String>? _excludedObservationIds;
  ListBuilder<String> get excludedObservationIds =>
      _$this._excludedObservationIds ??= ListBuilder<String>();
  set excludedObservationIds(ListBuilder<String>? excludedObservationIds) =>
      _$this._excludedObservationIds = excludedObservationIds;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AnalyticsCorrectionRequestBuilder() {
    AnalyticsCorrectionRequest._defaults(this);
  }

  AnalyticsCorrectionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _excludedObservationIds = $v.excludedObservationIds.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsCorrectionRequest other) {
    _$v = other as _$AnalyticsCorrectionRequest;
  }

  @override
  void update(void Function(AnalyticsCorrectionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsCorrectionRequest build() => _build();

  _$AnalyticsCorrectionRequest _build() {
    _$AnalyticsCorrectionRequest _$result;
    try {
      _$result = _$v ??
          _$AnalyticsCorrectionRequest._(
            excludedObservationIds: excludedObservationIds.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'AnalyticsCorrectionRequest', 'reason'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'excludedObservationIds';
        excludedObservationIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AnalyticsCorrectionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
