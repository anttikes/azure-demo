namespace Merus.Power.Demo.Products.API.Models;

public sealed class Product
{
    public Guid Id { get; }
    public string Name { get; }
    public decimal Price { get; }
    public int Quantity { get; }

    internal Product(Guid id, string name, decimal price, int quantity)
    {
        Id = id;
        Name = name;
        Price = price;
        Quantity = quantity;
    }
}
