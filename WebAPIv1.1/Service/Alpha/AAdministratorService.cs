using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;

namespace WebAPIv1._1.Service.Alpha
{
    public class AAdministratorService
    {
        //private readonly ProjectAlphaV1Context _context;
        private readonly ProjectAlphaV1Context _context;

        private readonly IConfiguration _configuration;

        public AAdministratorService(ProjectAlphaV1Context context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        //User Related

        public Auser Authenticate(string username, string password)
        {
            var query = _context.Ausers.SingleOrDefault(x => x.Username == username);

            // user not found or password is incorrect
            if (query == null || !VerifyPasswordHash(password, query.PasswordHash, query.PasswordSalt))
                return null;

            // authentication successful
            return query;
        }

        private bool VerifyPasswordHash(string password, string storedHash, string storedSalt)
        {
            byte[] salt = Convert.FromBase64String(storedSalt);
            byte[] hash = Convert.FromBase64String(storedHash);

            using (var hmac = new System.Security.Cryptography.HMACSHA512(salt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                for (int i = 0; i < computedHash.Length; i++)
                {
                    if (computedHash[i] != hash[i])
                        return false;
                }
            }
            return true;
        }


        public Auser Register(string username, string password)
        {
            if (string.IsNullOrWhiteSpace(password))
                throw new Exception("Password is required");

            if (_context.Ausers.Any(x => x.Username == username))
                throw new Exception("Username \"" + username + "\" is already taken");

            byte[] passwordHash, salt;
            CreatePasswordHash(password, out passwordHash, out salt);

            var user = new Auser
            {
                Username = username,
                PasswordHash = Convert.ToBase64String(passwordHash),
                PasswordSalt = Convert.ToBase64String(salt),
            };

            _context.Ausers.Add(user);
            _context.SaveChanges();

            return user;
        }

        private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] salt)
        {
            using (var hmac = new System.Security.Cryptography.HMACSHA512())
            {
                salt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            }
        }

        public string Generate(Auser user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(_configuration["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Username),
                new Claim(ClaimTypes.NameIdentifier, user.Username),
            };

            var token = new JwtSecurityToken(_configuration["Jwt:Issuer"],
              _configuration["Jwt:Audience"],
              claims,
              expires: DateTime.Now.AddHours(1),
              signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public Apersoninformation GetPerson(int? PersonId)
        {
            var query = _context.Apersoninformations.SingleOrDefault(x => x.PersonId == PersonId);

            return query;
        }

        public Auser ChangePassword(string username, string password, string newpassword)
        {
            // validation
            var query = _context.Ausers.SingleOrDefault(x => x.Username == username);

            if (query == null || !VerifyPasswordHash(password, query.PasswordHash, query.PasswordSalt))
                throw new Exception("User information not found in the database.");

            byte[] passwordHash, salt;
            CreatePasswordHash(newpassword, out passwordHash, out salt);


            query.PasswordHash = Convert.ToBase64String(passwordHash);
            query.PasswordSalt = Convert.ToBase64String(salt);

            _context.SaveChanges();

            return query;
        }

        public async Task<bool> SaveUserWithPerson(Auser model)
        {
            try
            {
                byte[] passwordHash, salt;
                CreatePasswordHash(model.PasswordHash, out passwordHash, out salt);

                var user = new Auser
                {
                    Username = model.Person.EmailAddress,
                    PasswordHash = Convert.ToBase64String(passwordHash), // Hashed password
                    PasswordSalt = Convert.ToBase64String(salt), // Salt used for hashing
                    DateCreated = DateTime.UtcNow,
                };

                var person = new Apersoninformation
                {
                    Firstname = model.Person.Firstname,
                    Lastname = model.Person.Lastname,
                    Middlename = model.Person.Middlename,
                    EmailAddress = model.Person.EmailAddress,
                    ContactNumber = model.Person.ContactNumber,

                };

                // Assign the person to the user
                user.Person = person;

                // Save changes
                _context.Ausers.Add(user);
                await _context.SaveChangesAsync();

                return true;
            }
            catch (Exception ex)
            {
                // Log or handle the exception as needed
                return false;
            }
        }

    }
}
