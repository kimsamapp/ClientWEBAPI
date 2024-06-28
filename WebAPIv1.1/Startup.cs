using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json.Serialization;
using System.IO;
using Microsoft.Extensions.FileProviders;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using WebAPIv1._1.Service.Alpha;
using WebAPIv1._1.ARepository;
using WebAPIv1._1.AModels;
//using WebAPIv1._1.Controllers.Alpha.External;
using Microsoft.EntityFrameworkCore;
using WebAPIv1._1.MySQLModels;

namespace WebAPIv1._1
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //services.AddDbContext<ProjectAlphaV1Context>(options =>
            // options.UseSqlServer(Configuration.GetConnectionString("MainDBCon")));

            services.AddDbContext<MySQLModels.ProjectAlphaV1Context>(options =>
             options.UseMySQL(Configuration.GetConnectionString("MainDBCon")));

            services.AddScoped(typeof(ARepository<>));
            services.AddScoped<AAdministratorService>();
            services.AddScoped<AContactUsService>();
            services.AddScoped<AFLinkService>();
            services.AddScoped<AFooterService>();
            services.AddScoped<AheaderService>();
            services.AddScoped<AHeaderServicesService>();
            services.AddScoped<APersonInformationService>();
            services.AddScoped<APropertyAmenitiesService>();
            services.AddScoped<APropertyInlusionsService>();
            services.AddScoped<APropertyService>();
            services.AddScoped<AUserService>();
            services.AddScoped<IFileService, FileService>();
            services.AddScoped<AContactUsService>();

            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = Configuration["Jwt:Issuer"],
                        ValidAudience = Configuration["Jwt:Audience"],
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
                    };
                });
            services.AddCors();

            //JSON Serializer
            services.AddControllersWithViews()
                .AddNewtonsoftJson(options => options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore)
                .AddNewtonsoftJson(options => options.SerializerSettings.ContractResolver = new DefaultContractResolver());
           
            services.AddControllers();

            services.AddSwaggerGen(s=>
            {
                s.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
                {
                    Version = "V1",
                    Title = "Project Alpha API",
                    Description = "Documentation for the Project Alpha APIs"
                });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseCors(x => x
              .AllowAnyMethod()
              .AllowAnyHeader()
              .SetIsOriginAllowed(origin => true) // allow any origin
              .AllowCredentials()); // allow credentials

            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                string swaggerJsonBasePath = string.IsNullOrWhiteSpace(c.RoutePrefix) ? "." : "..";
                c.SwaggerEndpoint($"{swaggerJsonBasePath}/swagger/v1/swagger.json", "Project Alpha API");

            });
            app.UseHttpsRedirection();

            app.UseAuthentication();
            app.UseRouting();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            app.UseStaticFiles(); // Enable static file serving
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(
                    Path.Combine(Directory.GetCurrentDirectory(), "Uploads")),
                RequestPath = "/Uploads"
            });
        }
    }
}
