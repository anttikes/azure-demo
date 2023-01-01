using System.Net;
using Merus.Power.Demo.Products.API.Data;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Merus.Power.Demo.Products.API;

/// <summary>
/// Provides product listing, searching and management features
/// </summary>
public sealed class Products
{
    private readonly ProductContext _context;

    public Products(ILoggerFactory loggerFactory, ProductContext context)
    {
        _context = context;
    }

    /// <summary>
    /// Returns all products
    /// </summary>
    /// <param name="req">An instance of <see cref="Microsoft.Azure.Functions.Worker.HttpTriggerAttribute" /> which defines the trigger properties and provides access to the http request</param>
    /// <param name="cancellationToken">An instance of <see cref="System.Threading.CancellationToken" /> which is triggered when host cancellation is requested</param>
    [Function(nameof(GetProducts))]
    public async Task<HttpResponseData> GetProducts(
        [HttpTrigger(AuthorizationLevel.Function, "GET", Route = "products")] HttpRequestData req,
        CancellationToken cancellationToken
    )
    {
        var allProducts = await _context.Products.ToListAsync(cancellationToken);

        var res = req.CreateResponse(System.Net.HttpStatusCode.OK);

        await res.WriteAsJsonAsync(allProducts);

        return res;
    }

    /// <summary>
    /// Creates a new product with zero initial quantity
    /// </summary>
    /// <param name="req">An instance of <see cref="Microsoft.Azure.Functions.Worker.HttpTriggerAttribute" /> which defines the trigger properties and provides access to the http request</param>
    /// <param name="cancellationToken">An instance of <see cref="System.Threading.CancellationToken" /> which is triggered when host cancellation is requested</param>
    [Function(nameof(CreateProduct))]
    public async Task<HttpResponseData> CreateProduct(
        [HttpTrigger(AuthorizationLevel.Function, "POST", Route = "products")] HttpRequestData req,
        CancellationToken cancellationToken
    )
    {
        Requests.CreateProduct? createRequest;

        try
        {
            createRequest = await req.ReadFromJsonAsync<Requests.CreateProduct>(cancellationToken);
        }
        catch(Exception ex)
        {
            var error = req.CreateResponse();
            await error.WriteAsJsonAsync(ex.Message, HttpStatusCode.BadRequest, cancellationToken);

            return error;
        }

        if (createRequest is null)
        {
            return req.CreateResponse(HttpStatusCode.BadRequest);
        }

        var newProduct = new Models.Product(Guid.NewGuid(), createRequest.Name, createRequest.Price, 0);

        _context.Products.Add(newProduct);

        await _context.SaveChangesAsync();

        return req.CreateResponse(HttpStatusCode.OK);
    }

    /// <summary>
    /// Updates the properties of a product
    /// </summary>
    /// <param name="req">An instance of <see cref="Microsoft.Azure.Functions.Worker.HttpTriggerAttribute" /> which defines the trigger properties and provides access to the http request</param>
    /// <param name="id">Unique identifier of the product to update
    /// <param name="cancellationToken">An instance of <see cref="System.Threading.CancellationToken" /> which is triggered when host cancellation is requested</param>
    [Function(nameof(UpdateProduct))]
    public async Task<HttpResponseData> UpdateProduct(
        [HttpTrigger(AuthorizationLevel.Function, "PUT", Route = "products/{id:guid}")] HttpRequestData req,
        Guid id,
        CancellationToken cancellationToken
    )
    {
        Requests.UpdateProduct? updateRequest;

        try
        {
            updateRequest = await req.ReadFromJsonAsync<Requests.UpdateProduct>(cancellationToken);
        }
        catch(Exception ex)
        {
            var error = req.CreateResponse();
            await error.WriteAsJsonAsync(ex.Message, HttpStatusCode.BadRequest, cancellationToken);

            return error;
        }

        if (updateRequest is null)
        {
            return req.CreateResponse(HttpStatusCode.BadRequest);
        }

        var updatedProduct = new Models.Product(id, string.Empty, 0.0m, 0);

        _context.Products.Attach(updatedProduct);

        if (!string.IsNullOrEmpty(updateRequest.Name))
        {
            updatedProduct.Name = updateRequest.Name;
        }

        if (updateRequest.Price.HasValue)
        {
            updatedProduct.Price = updateRequest.Price.Value;
        }

        if (updateRequest.Quantity.HasValue)
        {
            updatedProduct.Quantity = updateRequest.Quantity.Value;
        }

        await _context.SaveChangesAsync(cancellationToken);

        return req.CreateResponse(HttpStatusCode.OK);
    }

    /// <summary>
    /// Deletes the specified product
    /// </summary>
    /// <param name="req">An instance of <see cref="Microsoft.Azure.Functions.Worker.HttpTriggerAttribute" /> which defines the trigger properties and provides access to the http request</param>
    /// <param name="id">Unique identifier of the product to delete
    /// <param name="cancellationToken">An instance of <see cref="System.Threading.CancellationToken" /> which is triggered when host cancellation is requested</param>
    [Function(nameof(DeleteProduct))]
    public async Task<HttpResponseData> DeleteProduct(
        [HttpTrigger(AuthorizationLevel.Function, "DELETE", Route = "products/{id:guid}")] HttpRequestData req,
        Guid id,
        CancellationToken cancellationToken
    )
    {
        var product = new Models.Product(id, string.Empty, 0m, 0);

        _context.Products.Attach(product);
        _context.Products.Remove(product);

        await _context.SaveChangesAsync(cancellationToken);

        return req.CreateResponse(HttpStatusCode.OK);
    }
}
