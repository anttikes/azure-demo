namespace Merus.Power.Demo.Products.API.Requests;

public sealed class UpdateProduct
{    
    public string? Name { get; init; }
 
    public decimal? Price { get; init; }

    public int? Quantity { get; init; }
}
