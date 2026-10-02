// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_resolve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewResolveRequest extends ReviewResolveRequest {
  @override
  final String resolution;

  factory _$ReviewResolveRequest(
          [void Function(ReviewResolveRequestBuilder)? updates]) =>
      (ReviewResolveRequestBuilder()..update(updates))._build();

  _$ReviewResolveRequest._({required this.resolution}) : super._();
  @override
  ReviewResolveRequest rebuild(
          void Function(ReviewResolveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewResolveRequestBuilder toBuilder() =>
      ReviewResolveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewResolveRequest && resolution == other.resolution;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resolution.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewResolveRequest')
          ..add('resolution', resolution))
        .toString();
  }
}

class ReviewResolveRequestBuilder
    implements Builder<ReviewResolveRequest, ReviewResolveRequestBuilder> {
  _$ReviewResolveRequest? _$v;

  String? _resolution;
  String? get resolution => _$this._resolution;
  set resolution(String? resolution) => _$this._resolution = resolution;

  ReviewResolveRequestBuilder() {
    ReviewResolveRequest._defaults(this);
  }

  ReviewResolveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resolution = $v.resolution;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewResolveRequest other) {
    _$v = other as _$ReviewResolveRequest;
  }

  @override
  void update(void Function(ReviewResolveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewResolveRequest build() => _build();

  _$ReviewResolveRequest _build() {
    final _$result = _$v ??
        _$ReviewResolveRequest._(
          resolution: BuiltValueNullFieldError.checkNotNull(
              resolution, r'ReviewResolveRequest', 'resolution'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
