@extends('mail.layouts.base')

@section('preheader', $noticeBody)
@section('eyebrow', 'Vendor onboarding')
@section('heading', 'MateryalPH Vendor onboarding update')

@section('content')
@include('mail.partials.notice', ['text' => $noticeBody])
@endsection

@section('next')
Sign in to the Vendor Portal to review your onboarding status.
@endsection

@section('action')
@include('mail.notification-link')
@endsection

@section('security', 'MateryalPH will never ask you to send a password, one-time code, payment secret, or private document by email.')
