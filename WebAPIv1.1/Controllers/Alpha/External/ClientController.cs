using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;
using WebAPIv1._1.Service.Alpha;
using WebAPIv1._1.Service.External;
using WebAPIv1._1.MySQLModels;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClientController : ControllerBase
    {

        private readonly IClientService _propertyService;

        public ClientController(IClientService propertyService)
        {
            _propertyService = propertyService;
        }

        [HttpGet("GetPropertiesWithIsActiveForSale")]
        public async Task<ActionResult<List<Aproperty>>> GetPropertiesWithIsActiveForSale()
        {
            try
            {
                var properties = await _propertyService.GetPropertiesWithIsActiveForSale();
                return Ok(properties);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error retrieving properties: {ex.Message}");
            }
        }

        [HttpGet("GetPropertiesWithIsActiveForRent")]
        public async Task<ActionResult<List<Aproperty>>> GetPropertiesWithIsActiveForRent()
        {
            try
            {
                var properties = await _propertyService.GetPropertiesWithIsActiveForRent();
                return Ok(properties);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error retrieving properties: {ex.Message}");
            }
        }


        [HttpGet("GetPropertiesWithIsActiveByid/{id}")]
        public async Task<ActionResult<Aproperty>> GetPropertiesWithIsActiveByid(int id)
        {
            try
            {
                var properties = await _propertyService.GetPropertiesWithIsActiveByid(id);
                return Ok(properties);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error retrieving properties: {ex.Message}");
            }
        }
    }
}
