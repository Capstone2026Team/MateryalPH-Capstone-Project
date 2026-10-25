@extends('mail.layouts.base')

@section('preheader', $notice)
@section('eyebrow', 'Order update')
@section('heading', $noticeSubject)

@section('content')
@include('mail.partials.notice', ['text' => $notice])
@endsection

@section('next')
Open the order in MateryalPH to review its current status. Deadlines are shown in Philippine time (Asia/Manila).
@endsection

@section('action')
@include('mail.notification-link')
@endsection

@section('security', 'MateryalPH will never ask you to send a password, one-time code or payment details by email.')
