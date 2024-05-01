using Microsoft.AspNetCore.Http;
using System;
using System.Threading.Tasks;

namespace TKR.App
{
    public sealed class ExceptionMiddleware
    {
        private readonly CoreService _core;
        private readonly RequestDelegate _next;

        public ExceptionMiddleware(CoreService core, RequestDelegate next)
        {
            _core = core;
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next.Invoke(context);
            }
            catch (Exception ex)
            {
                if (ex is BadHttpRequestException badRequestException)
                {
                    context.Response.CreateError("Bad Request");
                    _core.Logger.Warn($"Bad Request From: {context.Connection.RemoteIpAddress} Exception: {badRequestException}");
                }
                else
                {
                    context.Response.CreateError("Internal Server Error");
                    _core.Logger.Warn($"{ex.GetType().Name} Internal Error From: {context.Connection.RemoteIpAddress}");
                }
            }
        }
    }
}
