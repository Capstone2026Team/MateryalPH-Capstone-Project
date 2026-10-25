<?php

declare(strict_types=1);

return [

    /*
     | Passwords are Argon2id. Sign-in accepts only Argon2 hashes, so an
     | environment that omits HASH_DRIVER must not fall back to Laravel's
     | bcrypt default: every reset or registration would become unusable.
     */
    'driver' => env('HASH_DRIVER', 'argon2id'),

];
