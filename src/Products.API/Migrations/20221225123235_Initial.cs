using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Merus.Power.Demo.Products.API.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Price = table.Column<decimal>(type: "decimal(10,2)", precision: 10, scale: 2, nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false, defaultValue: 0)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PRODUCTS_ID", x => x.Id);
                });

            migrationBuilder.InsertData(
                table: "Products",
                columns: new[] { "Id", "Name", "Price" },
                values: new object[,]
                {
                    { new Guid("3759773f-5690-43bd-8989-733a69480861"), "Book", 50.20m },
                    { new Guid("458d3a90-77b3-490b-aa59-a90b6ebb5d5c"), "Table", 400.00m },
                    { new Guid("53cb68e5-0657-45e2-bc8c-1f0fd82a7ae7"), "Monitor", 250.70m },
                    { new Guid("6dd2ac44-c1e7-43a6-9f9d-8414db38e9e9"), "Printer", 1540.50m },
                    { new Guid("80299b3a-f406-4223-a7ec-feb1da0924fe"), "Headphones", 350.00m },
                    { new Guid("be768005-0c60-40d6-9cfb-3af1b812c8ed"), "Charger", 30.00m },
                    { new Guid("fdac4098-0404-4227-8f4f-8e7ea06f9473"), "Computer", 2050.10m }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Products");
        }
    }
}
