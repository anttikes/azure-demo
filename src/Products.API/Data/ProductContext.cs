using Merus.Power.Demo.Products.API.Models;
using Microsoft.EntityFrameworkCore;

namespace Merus.Power.Demo.Products.API.Data;

/// <summary>
/// Entity Framework Core context class for <see cref="Models.Product" />
/// </summary>
public sealed class ProductContext : DbContext
{
    public DbSet<Product> Products => Set<Product>();

    /// <summary>
    /// Initializes a new instance of <see cref="ProductContext" />
    /// </summary>
    /// <param name="contextOptions">Context options</param>
    public ProductContext(DbContextOptions<ProductContext> contextOptions) : base(contextOptions)
    {
    }

    /// <summary>
    /// Configures model options for the context
    /// </summary>
    /// <param name="modelBuilder"></param>
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Product>(entityBuilder =>
        {
            entityBuilder.ToTable("Products");

            entityBuilder.HasKey(e => e.Id);

            entityBuilder.Property(e => e.Name)
                         .HasMaxLength(30);

            entityBuilder.Property(e => e.Price)
                         .HasPrecision(10, 2);

            entityBuilder.Property(e => e.Quantity)
                         .HasDefaultValue(0);
        });
    }
}
