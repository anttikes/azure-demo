namespace Products.API.Models;

public sealed class Product
{
    public Guid Id { get; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public int Quantity { get; set; }

    internal Product(Guid id, string name, decimal price, int quantity)
    {
        Id = id;
        Name = name;
        Price = price;
        Quantity = quantity;
    }
}
