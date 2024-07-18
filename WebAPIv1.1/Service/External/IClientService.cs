using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;

namespace WebAPIv1._1.Service.External
{
    public interface IClientService
    {
       Task<List<Aproperty>> GetPropertiesWithIsActiveForSale();
       Task<List<Aproperty>> GetPropertiesWithIsActiveForRent();
       Task<Aproperty> GetPropertiesWithIsActiveByid(int id);


    }
}

