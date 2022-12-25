using Merus.Power.Demo.Products.API.Data;
using Merus.Power.Demo.Products.API.Models;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Merus.Power.Demo.Products.API.Migrations
{
    /// <inheritdoc />
    public partial class SeedData : Migration
    {
        /// <summary>
        /// Seeds the "Product" table with some initial data
        /// </summary>
        /// <param name="migrationBuilder"></param>
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                nameof(ProductContext.Products),
                new[] { nameof(Product.Id), nameof(Product.Name), nameof(Product.Price), nameof(Product.Quantity) },
                new object[,] {
                    { Guid.NewGuid(), "Book",         50.20, 0},
                    { Guid.NewGuid(), "Computer",   2050.10, 0},
                    { Guid.NewGuid(), "Table",       400.00, 0},
                    { Guid.NewGuid(), "Monitor",     250.70, 0},
                    { Guid.NewGuid(), "Charger",      30.00, 0},
                    { Guid.NewGuid(), "Printer",    1540.50, 0},
                    { Guid.NewGuid(), "Headphones",  350.00, 0}
                });
        }

        /// <summary>
        /// Removes all data from the "Products" table
        /// </summary>
        /// <param name="migrationBuilder"></param>
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql($"DELETE FROM [{nameof(ProductContext.Products)}]");
        }
    }
}
