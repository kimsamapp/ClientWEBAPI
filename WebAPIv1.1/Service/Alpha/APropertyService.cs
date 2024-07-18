using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;
using Microsoft.EntityFrameworkCore;

namespace WebAPIv1._1.Service.Alpha
{
    public class APropertyService
    {
        private readonly ARepository<Aproperty> _repository;
        private readonly ProjectAlphaV1Context _dbContext;

        public APropertyService(ARepository<Aproperty> repository, ProjectAlphaV1Context dbContext)
        {
            _repository = repository;
            _dbContext= dbContext;
        }

        public async Task<IEnumerable<Aproperty>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Aproperty> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Aproperty entity)
        {
            await _repository.AddAsync(entity);
        }

        public async Task UpdateContactAsync(Aproperty entity)
        {
            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }

        public async Task<bool> UpdatePropertyCodeAsync(int propertyId, string newPropertyCode)
        {
            var property = await _dbContext.Aproperties.FindAsync(propertyId);

            if (property == null)
            {
                return false; // Property not found
            }

            property.PropertyCode = newPropertyCode;

            try
            {
                await _dbContext.SaveChangesAsync();
                return true; // Updated successfully
            }
            catch (DbUpdateException)
            {
                // Handle update exceptions if needed
                return false;
            }
        }

    }
}
