<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HalloController;

Route::get('/', [HalloController::class, 'index']);
