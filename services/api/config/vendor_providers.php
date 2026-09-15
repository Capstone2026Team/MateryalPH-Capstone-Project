<?php

return [
    'xendit' => [
        'mode' => env('XENDIT_MODE', 'test'),
        'secret' => env('XENDIT_SECRET_KEY'),
    ],
    'cloudinary' => [
        'cloud_name' => env('CLOUDINARY_CLOUD_NAME'),
        'api_key' => env('CLOUDINARY_API_KEY'),
        'api_secret' => env('CLOUDINARY_API_SECRET'),
    ],
];
