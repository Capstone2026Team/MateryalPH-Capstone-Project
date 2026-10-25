@extends('mail.layouts.base')

@section('eyebrow', 'Verification code')
@section('heading', 'Verify your MateryalPH account')

@section('content')
<p style="margin: 0; font-size: 16px; line-height: 26px; color: #1F2937;">Use this six-digit code for {{ str_replace('_', ' ', strtolower($purpose)) }}:</p>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 20px 0 0;">
<tr>
<td align="center" style="padding: 20px 16px; background-color: #F8FAFC; border: 1px solid #E5E7EB; border-radius: 8px; font-family: 'SFMono-Regular', Menlo, Consolas, 'Liberation Mono', monospace; font-size: 32px; line-height: 40px; font-weight: 700; letter-spacing: 0.3em; color: #1F2937;">{{ $code }}</td>
</tr>
</table>
<p style="margin: 16px 0 0; font-size: 14px; line-height: 22px; color: #475569;">This code expires in <strong style="color: #1F2937;">{{ $expiresInMinutes }} minutes</strong>.</p>
@endsection

@section('security', 'MateryalPH will never ask you to share this code. If you did not request it, you can ignore this email.')
