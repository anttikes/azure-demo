using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace Merus.Power.Azure.Demo
{
    public class Products
    {
        private readonly ILogger _logger;

        public Products(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<Products>();
        }

        [Function("GetProducts")]
        public HttpResponseData Run(
            [HttpTrigger(AuthorizationLevel.Function, "GET", Route = "products")] HttpRequestData req
        )
        {
            _logger.LogInformation("BEGIN: GET /api/products");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            _logger.LogInformation("END: GET /api/products");

            return response;
        }
    }
}
