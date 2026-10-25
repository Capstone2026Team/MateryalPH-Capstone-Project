@extends('mail.layouts.base')

@section('preheader', 'You have a one-time MateryalPH admin invitation.')
@section('eyebrow', 'Invitation')
@section('heading', 'MateryalPH admin invitation')

@section('content')
<p style="margin: 0; font-size: 16px; line-height: 26px; color: #1F2937;">An authorized bootstrap command created this one-time invitation.</p>
@endsection

@section('action')
@include('mail.partials.button', ['url' => $acceptUrl, 'label' => 'Accept the admin invitation', 'caption' => 'The link expires in 24 hours.'])
@endsection

@section('security', 'If you did not expect this invitation, do not use it.')

@section('reason', 'You received this email because this address was invited to MateryalPH.')
