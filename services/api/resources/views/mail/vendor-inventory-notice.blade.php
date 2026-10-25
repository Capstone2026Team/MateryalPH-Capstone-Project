@extends('mail.layouts.base')

@section('preheader', $notice)
@section('eyebrow', 'Inventory')
@section('heading', $noticeSubject)

@section('content')
@include('mail.partials.notice', ['text' => $notice])
@endsection

@section('next')
Sign in to the Vendor Portal and open <strong>My Products → Inventory</strong> to review your stock.
@endsection

@section('action')
@include('mail.notification-link')
@endsection

@section('security', 'MateryalPH will never ask you to send a password, one-time code or private document by email.')
