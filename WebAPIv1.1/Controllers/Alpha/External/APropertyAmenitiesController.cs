using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.Service.Alpha;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class APropertyAmenitiesController : ControllerBase
    {
        private readonly APropertyAmenitiesService _service;

        public APropertyAmenitiesController(APropertyAmenitiesService service)
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
        public async Task<IActionResult> Create(Apropertyamenity entity)
        {
            await _service.AddContactAsync(entity);
            return CreatedAtAction(nameof(Get), new { id = entity.ApropertyAmenityId }, entity);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Apropertyamenity entity)
        {
            if (id != entity.ApropertyAmenityId) return BadRequest();
            await _service.UpdateContactAsync(entity);
            return Ok(id);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.DeleteContactAsync(id);
            return Ok(id);
        }

        [Authorize]
        [HttpGet("GetForeignKey/{foreignKeyId}")]
        public async Task<IActionResult> GetForeignKey(int foreignKeyId)
        {
            var entity = await _service.GetEntityByForeignKeyAsync(foreignKeyId);
            if (entity == null || entity.Count == 0)
                return Ok(new List<Apropertyamenity>());

            return Ok(entity);
        }
    }
}
