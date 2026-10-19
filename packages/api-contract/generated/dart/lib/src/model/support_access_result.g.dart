// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_access_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportAccessResult extends SupportAccessResult {
  @override
  final String ticketId;

  factory _$SupportAccessResult(
          [void Function(SupportAccessResultBuilder)? updates]) =>
      (SupportAccessResultBuilder()..update(updates))._build();

  _$SupportAccessResult._({required this.ticketId}) : super._();
  @override
  SupportAccessResult rebuild(
          void Function(SupportAccessResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportAccessResultBuilder toBuilder() =>
      SupportAccessResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportAccessResult && ticketId == other.ticketId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportAccessResult')
          ..add('ticketId', ticketId))
        .toString();
  }
}

class SupportAccessResultBuilder
    implements Builder<SupportAccessResult, SupportAccessResultBuilder> {
  _$SupportAccessResult? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  SupportAccessResultBuilder() {
    SupportAccessResult._defaults(this);
  }

  SupportAccessResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportAccessResult other) {
    _$v = other as _$SupportAccessResult;
  }

  @override
  void update(void Function(SupportAccessResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportAccessResult build() => _build();

  _$SupportAccessResult _build() {
    final _$result = _$v ??
        _$SupportAccessResult._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
              ticketId, r'SupportAccessResult', 'ticketId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
