using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.DirectoryServices.AccountManagement;
using WebAPIv1._1.Model;

namespace WebAPIv1._1.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly string _connString;
        public LoginController(IConfiguration configuration)
        {
            _configuration = configuration;
            _connString = configuration.GetConnectionString("MainDBCon");
        }

        protected class DBStoredProceduresNames
        {
            public static readonly string SPLOGIN = "SPLOGIN";
            public static readonly string SPADMIN = "SPADMIN";
        }


        [AllowAnonymous]
        [HttpPost("LOGINADMINUSER")]
        public IActionResult LOGINADMINUSER(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPLOGIN, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@keyword", Convert.ToString(data.keyword != null ? data.keyword : "")));
                    cmd.Parameters.Add(new SqlParameter("@fid", Convert.ToString(data.fid != null ? data.fid : "")));
                    cmd.Parameters.Add(new SqlParameter("@password", Convert.ToString(data.password != null ? data.password : "")));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT != null ? data.actionT : "")));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

        [AllowAnonymous]
        [HttpPost("SPADMIN")]
        public IActionResult SPADMIN(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPADMIN, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@keyword", Convert.ToString(data.keyword != null ? data.keyword : "")));
                    cmd.Parameters.Add(new SqlParameter("@fid", Convert.ToString(data.fid != null ? data.fid : "")));
                    cmd.Parameters.Add(new SqlParameter("@password", Convert.ToString(data.password != null ? data.password : "")));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT != null ? data.actionT : "")));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

        [AllowAnonymous]
        [HttpPost("GENERATETOKSFORADMIN")]
        public IActionResult GENERATETOKSFORADMIN(UserModel data)
        {
            if (data.Username != "" && data.Role != "")
            {
                var token = Generate(data);
                return Ok(token);
            }

            return NotFound("Invalid Action, Generation of Token Error");
        }

        private string Generate(dynamic user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Username),
                new Claim(JwtRegisteredClaimNames.UniqueName, user.Role),
                new Claim(ClaimTypes.NameIdentifier, user.Username),
                new Claim(ClaimTypes.Role, user.Role),

            };

            var token = new JwtSecurityToken(_configuration["Jwt:Issuer"],
              _configuration["Jwt:Audience"],
              claims,
              expires: DateTime.Now.AddDays(2),
              signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
