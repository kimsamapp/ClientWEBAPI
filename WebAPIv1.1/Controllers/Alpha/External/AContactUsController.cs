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
    public class AContactUsController : ControllerBase
    {
        private readonly AContactUsService _service;

        public AContactUsController(AContactUsService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var contacts = await _service.GetAllContactsAsync();
            return Ok(contacts);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var contact = await _service.GetContactByIdAsync(id);
            if (contact == null) return NotFound();
            return Ok(contact);
        }

        [HttpPost]
        public async Task<IActionResult> Create(Acontactu contact)
        {
            await _service.AddContactAsync(contact);
            return CreatedAtAction(nameof(Get), new { id = contact.AcontactUsId }, contact);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Acontactu contact)
        {
            if (id != contact.AcontactUsId) return BadRequest();
            await _service.UpdateContactAsync(contact);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.DeleteContactAsync(id);
            return NoContent();
        }

    }
}
