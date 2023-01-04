using Azure.Core.Serialization;
using Products.API.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

// Configures the generic .NET host when running inside a Container App
var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults(options =>
    {
        var settings = NewtonsoftJsonObjectSerializer.CreateJsonSerializerSettings();
        settings.ContractResolver = new CamelCasePropertyNamesContractResolver();
        settings.NullValueHandling = NullValueHandling.Ignore;

        options.Serializer = new NewtonsoftJsonObjectSerializer();
    })
    .ConfigureServices(services =>
    {
        services.AddDbContext<ProductContext>();
    })
    .Build();

// Perform database migration at startup
var context = host.Services.GetRequiredService<ProductContext>();

context.Database.Migrate();

host.Run();
