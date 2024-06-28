using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.Service.Alpha;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class APersonInfromationController : ControllerBase
    {
        private readonly APersonInformationService _service;

        public APersonInfromationController(APersonInformationService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var entity = await _service.GetAllContactsAsync();
            return Ok(entity);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var entity = await _service.GetContactByIdAsync(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [HttpPost]
        public async Task<IActionResult> Create(Apersoninformation entity)
        {
            await _service.AddContactAsync(entity);
            return CreatedAtAction(nameof(Get), new { id = entity.PersonId }, entity);
        }

        //[HttpPut("{id}")]
        //public async Task<IActionResult> Update(int id, ApersonInformation entity)
        //{
        //    if (id != entity.PersonId) return BadRequest();
        //    await _service.UpdateContactAsync(entity);
        //    return NoContent();
        //}

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.DeleteContactAsync(id);
            return NoContent();
        }
    }
}
