@extends('mail.layouts.base')

@section('preheader', 'There is an update or an access request for support ticket '.$ticketNumber.'.')
@section('eyebrow', 'Support')
@section('heading', 'MateryalPH support')

@section('content')
<p style="margin: 0; font-size: 16px; line-height: 26px; color: #1F2937;">There is an update or an access request for support ticket <strong>{{ $ticketNumber }}</strong>.</p>
@endsection

@section('action')
@include('mail.partials.button', ['url' => $accessUrl, 'label' => 'Open your private support request', 'caption' => 'This single-use link expires in 24 hours and opens a 30-minute private session. Do not forward it. You can request a new link from Contact Us using your ticket number and email address.'])
@endsection

@section('security', 'Your messages and attachments are not included in email notifications. If you did not request support, you may ignore this email.')

@section('reason', 'You received this email because this address was used for a MateryalPH support request.')
