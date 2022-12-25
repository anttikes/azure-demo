using System.Net;
using System.Web;
using Merus.Power.Demo.Products.API.Data;
using Merus.Power.Demo.Products.API.Models;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;

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
    /// <returns>A collection of <see cref="Merus.Power.Demo.Products.API.Models.Product" /> instances</returns>    
    [Function("GetProducts")]
    public async Task<HttpResponseData> RunAsync(
        [HttpTrigger(AuthorizationLevel.Function, "GET", Route = "products")] HttpRequestData req,
        CancellationToken cancellationToken
    )
    {
        var allProducts = await _context.Products.ToListAsync(cancellationToken);

        var res = req.CreateResponse(System.Net.HttpStatusCode.OK);

        await res.WriteAsJsonAsync(allProducts);

        return res;
    }
}
