using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using Npgsql;

namespace Merus.Power.Demo
{
    internal class Product
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

    public class Products
    {
        private readonly ILogger _logger;

        public Products(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<Products>();
        }

        [Function("GetAllProducts")]
        public async Task<HttpResponseData> RunAsync(
            [HttpTrigger(AuthorizationLevel.Function, "GET", Route = "products")] HttpRequestData req,
            CancellationToken cancellationToken
        )
        {
            var connectionString = Environment.GetEnvironmentVariable("SQL_CONNECTION_STRING");

            if (string.IsNullOrEmpty(connectionString))
            {
                throw new ArgumentNullException($"The environment variable SQL_CONNECTION_STRING is not defined");
            }

            await using var dataSource = NpgsqlDataSource.Create(connectionString);

            var products = new List<Product>();

            await using (var cmd = dataSource.CreateCommand("SELECT * FROM public.Products"))
            await using (var reader = await cmd.ExecuteReaderAsync(cancellationToken))
            {
                while(await reader.ReadAsync(cancellationToken))
                {
                    var product = new Product(
                        reader.GetFieldValue<Guid>(0),
                        reader.GetFieldValue<string>(1),
                        reader.GetFieldValue<decimal>(2),
                        reader.GetFieldValue<int>(3)
                    );

                    products.Add(product);
                }
            }

            var res = req.CreateResponse(System.Net.HttpStatusCode.OK);

            await res.WriteAsJsonAsync(products);

            return res;
        }
    }
}
