using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class BulkController : ControllerBase
    {
        private readonly ProjectAlphaV1Context _context;

        public BulkController(ProjectAlphaV1Context context)
        {
            _context = context;
        }

        [HttpPost("bulk")]
        public async Task<IActionResult> BulkInsert<TEntity>(IEnumerable<TEntity> entities) where TEntity : class
        {
            if (entities == null || !entities.Any())
            {
                return BadRequest("No entities provided");
            }

            var repository = new ARepository<TEntity>(_context);
            await repository.AddEntitiesInBulkAsync(entities);

            return Ok("Bulk insert successful");
        }
    }
}
