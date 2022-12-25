using Merus.Power.Demo.Products.API.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

// Configures the generic .NET host when running inside a Container App
var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices(services =>
    {
        services.AddDbContext<ProductContext>(options => {
            options.UseNpgsql(Environment.GetEnvironmentVariable("SQL_CONNECTION_STRING"));
        });
    })
    .Build();

host.Run();
 