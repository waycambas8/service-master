<?php

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

$Service = 'master';

Route::group([
    'prefix' => $Service
], function () {
    Route::get('', function () {
        return response()->json([
            'msg' => "Beep Beep Service master is online with tag 0.0.6"
        ]);
    });
});
