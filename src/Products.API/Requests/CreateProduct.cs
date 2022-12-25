namespace Merus.Power.Demo.Products.API.Requests;

public sealed class CreateProduct
{
    public string Name { get; }

    public decimal Price { get; }

    public CreateProduct(string? name, decimal? price)
    {
        Name = name ?? throw new ArgumentNullException(nameof(name));
        Price = price ?? throw new ArgumentNullException(nameof(price));
    }
}
