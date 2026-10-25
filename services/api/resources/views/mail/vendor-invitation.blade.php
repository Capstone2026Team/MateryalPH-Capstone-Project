@extends('mail.layouts.base')

@section('preheader', 'You were invited to join a Vendor organization on MateryalPH.')
@section('eyebrow', 'Invitation')
@section('heading', 'MateryalPH team invitation')

@section('content')
<p style="margin: 0; font-size: 16px; line-height: 26px; color: #1F2937;">You were invited to join a Vendor organization using your own individual account.</p>
@endsection

@section('action')
@include('mail.partials.button', ['url' => $acceptUrl, 'label' => 'Review and accept your invitation', 'caption' => 'This invitation expires at the time selected by the inviter.'])
@endsection

@section('security', 'If you did not expect this invitation, do not accept it.')

@section('reason', 'You received this email because this address was invited to MateryalPH.')
