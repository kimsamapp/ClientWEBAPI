using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.Service.Alpha;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private readonly ContactService _service;

        public ContactsController(ContactService service)
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
        public async Task<IActionResult> Create(Afcontact contact)
        {
            await _service.AddContactAsync(contact);
            return CreatedAtAction(nameof(Get), new { id = contact.AfcontactsId }, contact);
        }

        //[HttpPut("{id}")]
        //public async Task<IActionResult> Update(int id, Afcontact contact)
        //{
        //    if (id != contact.Afcontacts) return BadRequest();
        //    await _service.UpdateContactAsync(contact);
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
