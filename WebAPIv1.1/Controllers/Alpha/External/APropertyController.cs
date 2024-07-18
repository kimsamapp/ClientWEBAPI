using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.Service.Alpha;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class APropertyController : ControllerBase
    {
        private readonly APropertyService _service;

        public APropertyController(APropertyService service)
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
        public async Task<IActionResult> Create(Aproperty entity)
        {
            await _service.AddContactAsync(entity);
            return CreatedAtAction(nameof(Get), new { id = entity.PropertyId }, entity);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Aproperty entity)
        {
            if (id != entity.PropertyId) return BadRequest();
            await _service.UpdateContactAsync(entity);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.DeleteContactAsync(id);
            return NoContent();
        }

        [Authorize]
        [HttpPut("updatePropertyCode/{propertyId}")]
        public async Task<IActionResult> UpdatePropertyCode(int propertyId, [FromBody] string newPropertyCode)
        {
            if (string.IsNullOrEmpty(newPropertyCode))
            {
                return BadRequest("New property code cannot be empty.");
            }

            var result = await _service.UpdatePropertyCodeAsync(propertyId, newPropertyCode);

            if (result)
            {
                return Ok($"Property with ID {propertyId} updated successfully.");
            }
            else
            {
                return NotFound($"Property with ID {propertyId} not found.");
            }
        }


    }
}
