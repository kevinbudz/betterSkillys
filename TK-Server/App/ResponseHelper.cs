using Microsoft.AspNetCore.Http;
using System.Text;

namespace App
{
    public static class ResponseHelper
    {
        public static async void InternalServerError(this HttpResponse httpResponse, string error)
        {
            httpResponse.StatusCode = 500;
            await httpResponse.Body.WriteAsync(Encoding.UTF8.GetBytes($"<Error>Internal Server Error</Error>"));
        }

        public static async void CreateError(this HttpResponse httpResponse, string error)
        {
            httpResponse.StatusCode = 404;
            httpResponse.ContentType = "application/xml";
            await httpResponse.Body.WriteAsync(Encoding.UTF8.GetBytes($"<Error>{error}</Error>"));
        }

        public static async void CreateFatalError(this HttpResponse httpResponse, string error)
        {
            httpResponse.StatusCode = 404;
            httpResponse.ContentType = "application/xml";
            await httpResponse.Body.WriteAsync(Encoding.UTF8.GetBytes($"<FatalError>{error}</FatalError>"));
        }

        public static async void CreateSuccess(this HttpResponse httpResponse)
        {
            httpResponse.ContentType = "text/plain";
            await httpResponse.Body.WriteAsync(Encoding.UTF8.GetBytes("<Success/>"));
        }

        public static async void CreateText(this HttpResponse httpResponse, string text)
        {
            httpResponse.ContentType = "text/plain";
            await httpResponse.Body.WriteAsync(Encoding.UTF8.GetBytes(text));
        }

        public static async void CreateXml(this HttpResponse httpResponse, string xml)
        {
            httpResponse.ContentType = "application/xml";
            await httpResponse.Body.WriteAsync(Encoding.UTF8.GetBytes(xml));
        }

        public static async void CreateBytes(this HttpResponse httpResponse, byte[] bytes) => await httpResponse.Body.WriteAsync(bytes);
    }
}
