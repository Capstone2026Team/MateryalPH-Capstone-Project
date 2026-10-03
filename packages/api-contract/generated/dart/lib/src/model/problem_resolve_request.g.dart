// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_resolve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProblemResolveRequest extends ProblemResolveRequest {
  @override
  final String? note;

  factory _$ProblemResolveRequest(
          [void Function(ProblemResolveRequestBuilder)? updates]) =>
      (ProblemResolveRequestBuilder()..update(updates))._build();

  _$ProblemResolveRequest._({this.note}) : super._();
  @override
  ProblemResolveRequest rebuild(
          void Function(ProblemResolveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProblemResolveRequestBuilder toBuilder() =>
      ProblemResolveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProblemResolveRequest && note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProblemResolveRequest')
          ..add('note', note))
        .toString();
  }
}

class ProblemResolveRequestBuilder
    implements Builder<ProblemResolveRequest, ProblemResolveRequestBuilder> {
  _$ProblemResolveRequest? _$v;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ProblemResolveRequestBuilder() {
    ProblemResolveRequest._defaults(this);
  }

  ProblemResolveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProblemResolveRequest other) {
    _$v = other as _$ProblemResolveRequest;
  }

  @override
  void update(void Function(ProblemResolveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProblemResolveRequest build() => _build();

  _$ProblemResolveRequest _build() {
    final _$result = _$v ??
        _$ProblemResolveRequest._(
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
