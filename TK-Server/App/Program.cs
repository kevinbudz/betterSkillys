using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;

namespace App
{
    public sealed class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            var service = builder.Services;

            service.AddSingleton<CoreService>();
            service.AddControllers();

#if DEBUG
            service.AddEndpointsApiExplorer();
            service.AddSwaggerGen();
#endif

            var app = builder.Build();

            var core = app.Services.GetService<CoreService>();

            app.Urls.Clear();
#if DEBUG
            var address = "localhost";
#else
            var address = core.Config.serverInfo.bindAddress;
#endif
            app.Urls.Add($"http://{address}:{core.Config.serverInfo.port}");
            
            if (!core.IsProduction())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseStaticFiles(new StaticFileOptions()
            {
                FileProvider = new PhysicalFileProvider($"{core.Resources.ResourcePath}/web/sfx"),
                RequestPath = "/sfx"
            });

            app.UseStaticFiles(new StaticFileOptions()
            {
                FileProvider = new PhysicalFileProvider($"{core.Resources.ResourcePath}/web/music"),
                RequestPath = "/music"
            });

            //app.UseHttpsRedirection();
            app.UseRouting();
            app.UseAuthorization();
            app.MapControllers(); //app.MapEndpoints(endpoints => endpoints.MapControllers());

            app.Use(async (context, next) =>
            {
                core.Logger.Info($"Request: \"{context.Request.Path}\" from: {context.Connection.RemoteIpAddress}");
                await next();
            });
            
            app.UseMiddleware<ExceptionMiddleware>();

            app.Run();
        }
    }
}