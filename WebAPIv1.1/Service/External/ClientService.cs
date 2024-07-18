using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;

namespace WebAPIv1._1.Service.External
{
    public class ClientService : IClientService
    {
        private readonly ProjectAlphaV1Context _dbContext;

        public ClientService(ProjectAlphaV1Context dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<Aproperty>> GetPropertiesWithIsActiveForSale()
        {
            return await _dbContext.Aproperties
                .Include(p => p.Apropertyamenities)
                .Include(p => p.Apropertyinclusions)
               .Where(p => p.IsActive == 2 && p.AheaderServicesId == 1)
               .ToListAsync();
        }

        public async Task<List<Aproperty>> GetPropertiesWithIsActiveForRent()
        {
            return await _dbContext.Aproperties
                .Include(p => p.Apropertyamenities)
                .Include(p => p.Apropertyinclusions)
               .Where(p => p.IsActive == 2 && p.AheaderServicesId == 2)
               .ToListAsync();
        }

        public async Task<Aproperty> GetPropertiesWithIsActiveByid(int id)
        {
            return await _dbContext.Aproperties
                .Include(p => p.Apropertyamenities)
                .Include(p => p.Apropertyinclusions)
               .Where(p => p.IsActive == 2 && p.PropertyId == id)
               .FirstOrDefaultAsync();
        }
    }
}
