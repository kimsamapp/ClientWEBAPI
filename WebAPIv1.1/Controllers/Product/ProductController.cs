using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data;
using System;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Authorization;

namespace WebAPIv1._1.Controllers.Product
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly string _connString;
        public ProductController(IConfiguration configuration)
        {
            _configuration = configuration;
            _connString = configuration.GetConnectionString("MainDBCon");
        }

        protected class DBStoredProceduresNames
        {
            public static readonly string SPBRAND = "SPBRAND";
            public static readonly string SPMODEL = "SPMODEL";
            public static readonly string SPTYPE = "SPTYPE";
            public static readonly string SPSIZE = "SPSIZE";
            public static readonly string SPPRODUCT = "SPPRODUCT";
            public static readonly string SPSTOCKADJUSTMENT = "SPSTOCKADJUSTMENT";
            public static readonly string SPDISCOUNT = "SPDISCOUNT";
            public static readonly string SPORDERS = "SPORDERS";
            public static readonly string SPPRICES = "SPPRICES";
        }

        [HttpPost("SPBRAND")]
        [Authorize]
        public dynamic SPBRAND(dynamic data)
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

        [HttpPost("SPMODEL")]
        [Authorize]
        public dynamic SPMODEL(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPMODEL, sql))
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

        [HttpPost("SPTYPE")]
        [Authorize]
        public dynamic SPTYPE(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPTYPE, sql))
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

        [HttpPost("SPSIZE")]
        [Authorize]
        public dynamic SPSIZE(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPSIZE, sql))
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

        [HttpPost("SPSTOCKADJUSTMENT")]
        [Authorize]
        public dynamic SPSTOCKADJUSTMENT(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPSTOCKADJUSTMENT, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@keyword", Convert.ToString(data.keyword)));
                    cmd.Parameters.Add(new SqlParameter("@prodid", Convert.ToString(data.prodid)));
                    cmd.Parameters.Add(new SqlParameter("@userid", Convert.ToString(data.userid)));
                    cmd.Parameters.Add(new SqlParameter("@quantity", Convert.ToString(data.quantity)));
                    cmd.Parameters.Add(new SqlParameter("@previousquantity", Convert.ToString(data.previousquantity)));
                    cmd.Parameters.Add(new SqlParameter("@reason", Convert.ToString(data.reason)));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT)));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

        [HttpPost("SPPRICES")]
        [Authorize]
        public dynamic SPPRICES(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPPRICES, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@keyword", Convert.ToString(data.keyword)));
                    cmd.Parameters.Add(new SqlParameter("@prodid", Convert.ToString(data.prodid)));
                    cmd.Parameters.Add(new SqlParameter("@userid", Convert.ToString(data.userid)));
                    cmd.Parameters.Add(new SqlParameter("@price", Convert.ToDecimal(data.quantity)));
                    cmd.Parameters.Add(new SqlParameter("@previousprice", Convert.ToDecimal(data.previousquantity)));
                    cmd.Parameters.Add(new SqlParameter("@reason", Convert.ToString(data.reason)));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT)));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

        [HttpPost("SPPRODUCT")]
        [Authorize]
        public dynamic SPPRODUCT(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPPRODUCT, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@keyword", Convert.ToString(data.keyword != null ? data.keyword : "")));
                    cmd.Parameters.Add(new SqlParameter("@id", Convert.ToString(data.id != null ? data.id : 0)));
                    cmd.Parameters.Add(new SqlParameter("@name", Convert.ToString(data.name != null ? data.name : "")));
                    cmd.Parameters.Add(new SqlParameter("@description", Convert.ToString(data.description != null ? data.description : "")));
                    cmd.Parameters.Add(new SqlParameter("@status", Convert.ToString(data.status != null ? data.status : 0)));
                    cmd.Parameters.Add(new SqlParameter("@suppliername", Convert.ToString(data.suppliername != null ? data.suppliername : "")));
                    cmd.Parameters.Add(new SqlParameter("@attachmentid", Convert.ToString(data.attachmentid != null ? data.attachmentid : 0)));
                    cmd.Parameters.Add(new SqlParameter("@attachment", Convert.ToString(data.attachment != null ? data.attachment : "")));
                    cmd.Parameters.Add(new SqlParameter("@serial", Convert.ToString(data.serial != null ? data.serial : "")));
                    cmd.Parameters.Add(new SqlParameter("@amount", Convert.ToDecimal(data.amount != null ? data.amount : 0)));
                    cmd.Parameters.Add(new SqlParameter("@groupid", Convert.ToString(data.groupid != null ? data.groupid : 0)));
                    cmd.Parameters.Add(new SqlParameter("@brandid", Convert.ToString(data.brandid != null ? data.brandid : 0)));
                    cmd.Parameters.Add(new SqlParameter("@sizeid", Convert.ToString(data.sizeid != null ? data.sizeid : 0)));
                    cmd.Parameters.Add(new SqlParameter("@stocks", Convert.ToString(data.stocks != null ? data.stocks : 0)));
                    cmd.Parameters.Add(new SqlParameter("@modelid", Convert.ToString(data.modelid != null ? data.modelid : 0)));
                    cmd.Parameters.Add(new SqlParameter("@typeid", Convert.ToString(data.typeid != null ? data.typeid : 0)));
                    cmd.Parameters.Add(new SqlParameter("@price", Convert.ToDecimal(data.price != null ? data.price : 0)));
                    cmd.Parameters.Add(new SqlParameter("@isactive", Convert.ToString(data.isactive != null ? data.isactive : 0)));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT)));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

        [HttpPost("SPDISCOUNT")]
        [Authorize]
        public dynamic SPDISCOUNT(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPDISCOUNT, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@keyword", Convert.ToString(data.keyword != null ? data.keyword : "")));
                    cmd.Parameters.Add(new SqlParameter("@id", Convert.ToString(data.id != null ? data.id : 0)));
                    cmd.Parameters.Add(new SqlParameter("@name", Convert.ToString(data.name)));
                    cmd.Parameters.Add(new SqlParameter("@description", Convert.ToString(data.description)));
                    cmd.Parameters.Add(new SqlParameter("@quantity", Convert.ToString(data.quantity)));
                    cmd.Parameters.Add(new SqlParameter("@type", Convert.ToString(data.type)));
                    cmd.Parameters.Add(new SqlParameter("@amount", Convert.ToDecimal(data.amount)));
                    cmd.Parameters.Add(new SqlParameter("@minimum", Convert.ToDecimal(data.minimum)));
                    cmd.Parameters.Add(new SqlParameter("@percentage", Convert.ToString(data.percentage)));
                    cmd.Parameters.Add(new SqlParameter("@expiredate", Convert.ToDateTime(DateTime.Now)));
                    cmd.Parameters.Add(new SqlParameter("@isactive", Convert.ToString(data.isactive != null ? data.isactive : 0)));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT)));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

        [HttpPost("SPORDERS")]
        [Authorize]
        public dynamic SPORDERS(dynamic data)
        {
            using (SqlConnection sql = new SqlConnection(_connString))
            {
                using (SqlCommand cmd = new SqlCommand(DBStoredProceduresNames.SPORDERS, sql))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@CUSTOMERNAME", Convert.ToString(data.@CUSTOMERNAME != null ? data.@CUSTOMERNAME : "")));
                    cmd.Parameters.Add(new SqlParameter("@ORDERID", Convert.ToString(data.ORDERID != null ? data.ORDERID : 0)));
                    cmd.Parameters.Add(new SqlParameter("@CUSTOMERID", Convert.ToString(data.CUSTOMERID != null ? data.CUSTOMERID : 0)));
                    cmd.Parameters.Add(new SqlParameter("@ISSTATUS", Convert.ToString(data.ISSTATUS != null ? data.ISSTATUS : 0)));
                    cmd.Parameters.Add(new SqlParameter("@ORDERDETAILID", Convert.ToString(data.ORDERDETAILID != null ? data.ORDERDETAILID : 0)));
                    cmd.Parameters.Add(new SqlParameter("@QUANTITY", Convert.ToString(data.QUANTITY != null ? data.QUANTITY : 0)));
                    cmd.Parameters.Add(new SqlParameter("@TAX", Convert.ToDecimal(data.TAX != null ? data.TAX :0)));
                    cmd.Parameters.Add(new SqlParameter("@TOTALAMOUNT", Convert.ToDecimal(data.TOTALAMOUNT != null ? data.TOTALAMOUNT : 0)));
                    cmd.Parameters.Add(new SqlParameter("@PRODID", Convert.ToString(data.PRODID != null ? data.PRODID : 0)));
                    cmd.Parameters.Add(new SqlParameter("@PAYMENTID", Convert.ToString(data.PAYMENTID != null ? data.PAYMENTID : 0)));
                    cmd.Parameters.Add(new SqlParameter("@PAYMENTTYPEID", Convert.ToString(data.PAYMENTTYPEID != null ? data.PAYMENTTYPEID : 0)));
                    cmd.Parameters.Add(new SqlParameter("@PRICE", Convert.ToDecimal(data.PRICE != null ? data.PRICE : 0)));
                    cmd.Parameters.Add(new SqlParameter("@TOTALCHANGE", Convert.ToDecimal(data.TOTALCHANGE != null ? data.TOTALCHANGE : 0)));
                    cmd.Parameters.Add(new SqlParameter("@ISACTIVE", Convert.ToString(data.ISACTIVE != null ? data.ISACTIVE : 0)));
                    cmd.Parameters.Add(new SqlParameter("@actionT", Convert.ToString(data.actionT)));
                    sql.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    return Ok(dt);
                }
            }
        }

    }
}
