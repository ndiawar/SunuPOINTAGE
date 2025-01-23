<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckFonction
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, $fonction): Response
    {
        if ($request->user()->fonction !== $fonction) {
            return response()->json(['message' => 'Accès non autorisé'], 403);
        }

        return $next($request);    }
}
