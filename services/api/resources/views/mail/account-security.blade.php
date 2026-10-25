@extends('mail.layouts.base')

@section('preheader', $notice)
@section('eyebrow', 'Account security')
@section('heading', 'Account security notice')

@section('content')
@include('mail.partials.notice', ['text' => $notice])
@endsection

@section('next')
If you did not authorize this action, contact MateryalPH support.
@endsection

@section('security', 'MateryalPH will never ask you to send a password or one-time code by email.')
