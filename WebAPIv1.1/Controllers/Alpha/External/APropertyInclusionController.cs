using DocumentFormat.OpenXml.Office2010.ExcelAc;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.Service.Alpha;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class APropertyInclusionController : ControllerBase
    {
        private readonly APropertyInlusionsService _service;

        public APropertyInclusionController(APropertyInlusionsService service)
        {
            _service = service;
        }

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var entity = await _service.GetAllContactsAsync();
            return Ok(entity);
        }

        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var entity = await _service.GetContactByIdAsync(id);
            if (entity == null) return NotFound();
            return Ok(entity);
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Create(Apropertyinclusion entity)
        {
            await _service.AddContactAsync(entity);
            return CreatedAtAction(nameof(Get), new { id = entity.ApropertyInclusionId }, entity);
        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Apropertyinclusion entity)
        {
            if (id != entity.ApropertyInclusionId) return BadRequest();
            await _service.UpdateContactAsync(entity);
            return Ok(id);
        }

        [Authorize]
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
                return Ok(new List<Apropertyinclusion>());

            return Ok(entity);
        }
    }
}
