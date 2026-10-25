@extends('mail.layouts.base')

@section('preheader', $notice)
@section('eyebrow', 'Product compliance')
@section('heading', 'MateryalPH product compliance update')

@section('content')
@include('mail.partials.notice', ['text' => $notice])
<p style="margin: 16px 0 0; font-size: 13px; line-height: 20px; color: #475569;">MateryalPH review is a marketplace control, not a DTI-BPS certification.</p>
@endsection

@section('next')
Sign in to the Vendor Portal and open <strong>My Products</strong> to see the decision and any correction requested.
@endsection

@section('action')
@include('mail.notification-link')
@endsection

@section('security', 'MateryalPH will never ask you to send a password, one-time code or private document by email.')
