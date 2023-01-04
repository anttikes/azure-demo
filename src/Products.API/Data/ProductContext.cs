using Products.API.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Products.API.Data;

/// <summary>
/// Entity Framework Core context class for <see cref="Models.Product" />
/// </summary>
public sealed class ProductContext : DbContext
{
    public DbSet<Product> Products => Set<Product>();

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
#if !DEBUG
        optionsBuilder.UseModel(global::Products.API.CompiledModels.ProductContextModel.Instance);
#endif
        optionsBuilder.UseSqlServer(Environment.GetEnvironmentVariable("SQL_CONNECTION_STRING"));

        optionsBuilder.EnableDetailedErrors();
        optionsBuilder.LogTo(Console.WriteLine, LogLevel.Information);
    }

    /// <inheritdoc />
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Product>(entityBuilder =>
        {
            entityBuilder.HasKey(e => e.Id)
                         .HasName("PK_PRODUCTS_ID");

            entityBuilder.Property(e => e.Name)
                         .HasMaxLength(30);

            entityBuilder.Property(e => e.Price)
                         .HasPrecision(10, 2);

            entityBuilder.Property(e => e.Quantity)
                         .HasDefaultValue(0);
        });

        modelBuilder.Entity<Product>().HasData(
            new Product(Guid.Parse("3759773f-5690-43bd-8989-733a69480861"), "Book", 50.20m, 0),
            new Product(Guid.Parse("fdac4098-0404-4227-8f4f-8e7ea06f9473"), "Computer", 2050.10m, 0),
            new Product(Guid.Parse("458d3a90-77b3-490b-aa59-a90b6ebb5d5c"), "Table", 400.00m, 0),
            new Product(Guid.Parse("53cb68e5-0657-45e2-bc8c-1f0fd82a7ae7"), "Monitor", 250.70m, 0),
            new Product(Guid.Parse("be768005-0c60-40d6-9cfb-3af1b812c8ed"), "Charger", 30.00m, 0),
            new Product(Guid.Parse("6dd2ac44-c1e7-43a6-9f9d-8414db38e9e9"), "Printer", 1540.50m, 0),
            new Product(Guid.Parse("80299b3a-f406-4223-a7ec-feb1da0924fe"), "Headphones", 350.00m, 0)
        );
    }
}
