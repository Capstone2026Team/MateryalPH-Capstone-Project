@extends('mail.layouts.base')

@section('preheader', $notice)
@section('eyebrow', 'Finance')
@section('heading', $noticeSubject)

@section('content')
@include('mail.partials.notice', ['text' => $notice])
<p style="margin: 16px 0 0; font-size: 13px; line-height: 20px; color: #475569;">All amounts in this capstone release are TEST/DEMO figures: no real tax was withheld or remitted and no BIR filing occurred.</p>
@endsection

@section('next')
Open <strong>Finance</strong> in MateryalPH to review the details.
@endsection

@section('action')
@include('mail.notification-link', ['purposeLabel' => 'View finance details'])
@endsection

@section('security', 'MateryalPH will never ask you to send a password, one-time code or payment details by email.')
