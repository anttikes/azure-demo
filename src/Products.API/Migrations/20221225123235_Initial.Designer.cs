﻿// <auto-generated />
using System;
using Products.API.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace Products.API.Migrations
{
    [DbContext(typeof(ProductContext))]
    [Migration("20221225123235_Initial")]
    partial class Initial
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.1")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("Products.API.Models.Product", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uniqueidentifier");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(30)
                        .HasColumnType("nvarchar(30)");

                    b.Property<decimal>("Price")
                        .HasPrecision(10, 2)
                        .HasColumnType("decimal(10,2)");

                    b.Property<int>("Quantity")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasDefaultValue(0);

                    b.HasKey("Id")
                        .HasName("PK_PRODUCTS_ID");

                    b.ToTable("Products");

                    b.HasData(
                        new
                        {
                            Id = new Guid("3759773f-5690-43bd-8989-733a69480861"),
                            Name = "Book",
                            Price = 50.20m,
                            Quantity = 0
                        },
                        new
                        {
                            Id = new Guid("fdac4098-0404-4227-8f4f-8e7ea06f9473"),
                            Name = "Computer",
                            Price = 2050.10m,
                            Quantity = 0
                        },
                        new
                        {
                            Id = new Guid("458d3a90-77b3-490b-aa59-a90b6ebb5d5c"),
                            Name = "Table",
                            Price = 400.00m,
                            Quantity = 0
                        },
                        new
                        {
                            Id = new Guid("53cb68e5-0657-45e2-bc8c-1f0fd82a7ae7"),
                            Name = "Monitor",
                            Price = 250.70m,
                            Quantity = 0
                        },
                        new
                        {
                            Id = new Guid("be768005-0c60-40d6-9cfb-3af1b812c8ed"),
                            Name = "Charger",
                            Price = 30.00m,
                            Quantity = 0
                        },
                        new
                        {
                            Id = new Guid("6dd2ac44-c1e7-43a6-9f9d-8414db38e9e9"),
                            Name = "Printer",
                            Price = 1540.50m,
                            Quantity = 0
                        },
                        new
                        {
                            Id = new Guid("80299b3a-f406-4223-a7ec-feb1da0924fe"),
                            Name = "Headphones",
                            Price = 350.00m,
                            Quantity = 0
                        });
                });
#pragma warning restore 612, 618
        }
    }
}
