using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using WebAPIv1._1.AModels;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.Service.Alpha;

namespace WebAPIv1._1.Controllers.Alpha.Administrator
{
    [Route("api/[controller]")]
    [ApiController]
    public class AlphaAdminController : ControllerBase
    {
        private readonly AAdministratorService _alphaService;
        public AlphaAdminController(AAdministratorService alphaService)
        {
            _alphaService = alphaService;
        }

        [HttpPost("login")]
        public IActionResult Login(LoginModel model)
        {
            try
            {
                var user = _alphaService.Authenticate(model.Username, model.Password);
                if (user == null)
                    return BadRequest(new { message = "Username or password is incorrect" });

                var person = _alphaService.GetPerson(user.PersonId);
                var token = _alphaService.Generate(user);

                // return user details without password
                return Ok(new
                {
                    PersonId = user.PersonId,
                    Username = user.Username,
                    FirstName = person?.Firstname,
                    LastName = person?.Lastname,
                    MiddleName = person?.Middlename,
                    ContactNumber = person?.ContactNumber,
                    EmailAddress = person?.EmailAddress,
                    Token = token
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }


        [HttpPost("register")]
        public IActionResult Register(string username, string password)
        {
            try
            {
                _alphaService.Register(username, password);
                return Ok("User registered successfully");
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("changepassword")]
        public IActionResult ChangePassword(LoginModel model)
        {
            try
            {
                _alphaService.ChangePassword(model.Username, model.Password, model.NewPassword);
                return Ok("User password changed successfully.");
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreateUser(MySQLModels.Auser model)
        {
          

            var result = await _alphaService.SaveUserWithPerson(model);

            if (result)
            {
                return Ok("User created successfully.");
            }
            else
            {
                return StatusCode(500, "Failed to create user.");
            }
        }


    }
}
