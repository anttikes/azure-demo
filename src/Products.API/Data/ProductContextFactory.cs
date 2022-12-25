using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Merus.Power.Demo.Products.API.Data;

public sealed class ProductContextFactory : IDesignTimeDbContextFactory<ProductContext>
{
    public ProductContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<ProductContext>();
        optionsBuilder.UseNpgsql(Environment.GetEnvironmentVariable("SQL_CONNECTION_STRING"));

        return new ProductContext(optionsBuilder.Options);
    }
}