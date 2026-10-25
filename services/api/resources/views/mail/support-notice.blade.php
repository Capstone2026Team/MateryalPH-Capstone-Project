@extends('mail.layouts.base')

@section('preheader', $noticeBody)
@section('eyebrow', 'Support')
@section('heading', $noticeSubject)

@section('content')
@include('mail.partials.notice', ['text' => $noticeBody])
<p style="margin: 16px 0 0; font-size: 13px; line-height: 20px; color: #475569;">Your private messages and attachments are available only in the support ticket.</p>
@endsection

@section('next')
@if($accountType === 'BUYER')
Open MateryalPH and go to <strong>Profile → Help Center → My Support Requests</strong> to read the update and reply.
@elseif($accountType === 'VENDOR')
Open <strong>My Support Requests</strong> in the Vendor portal to read the update and reply.
@else
Open <strong>Support Requests</strong> in the Admin portal to review the ticket.
@endif
@endsection

@section('action')
@include('mail.notification-link')
@endsection

@section('security', 'MateryalPH will never ask you to send a password, one-time code or payment details by email.')
