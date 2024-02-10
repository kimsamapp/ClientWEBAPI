using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Threading.Tasks;
using WebAPIv1._1.Model;

namespace WebAPIv1._1.Controllers.Upload
{
    [Route("api/[controller]")]
    [ApiController]
    public class UploadController : ControllerBase
    {
        public static IWebHostEnvironment _webHostEnvironment;
        private readonly IConfiguration _configuration;
        private readonly string _connString;

        protected class DBStoredProceduresNames
        {
            public static readonly string SPBRAND = "SPBRAND";
        }


        public UploadController(IWebHostEnvironment webHostEnvironment, IConfiguration configuration) {
            _configuration = configuration;
            _connString = configuration.GetConnectionString("MainDBCon");
            _webHostEnvironment = webHostEnvironment;
        }

        [HttpPost("UploadAttachmentOfProduct")]
        [Authorize]
        public dynamic UploadAttachmentOfProduct(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPBRAND, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@keyword", Convert.ToString(data.keyword)));
                    cmd.Parameters.Add(new SqlParameter("@id", Convert.ToString(data.id)));
                    cmd.Parameters.Add(new SqlParameter("@name", Convert.ToString(data.name)));
                    cmd.Parameters.Add(new SqlParameter("@isactive", Convert.ToString(data.isactive)));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT)));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

        [HttpPost]
        public async Task<string> Post([FromForm] FileUpload fileUpload)
        {
            try
            {
                if (fileUpload.files.Length > 0)
                {
                    string path = _webHostEnvironment.WebRootPath + "\\uploads\\";
                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }
                    using (FileStream fileStream = System.IO.File.Create(path + fileUpload.files.FileName))
                    {

                        fileUpload.files.CopyTo(fileStream);
                        fileStream.Flush();
                        return "Upload Done";
                    }
                }
                else {
                    return "Failed.";
                }
            }
            catch (Exception ex) {
                return ex.Message;
            }
        }

    }
}
