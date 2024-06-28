using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class APropertyInlusionsService
    {
        private readonly ARepository<Apropertyinclusion> _repository;

        public APropertyInlusionsService(ARepository<Apropertyinclusion> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Apropertyinclusion>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Apropertyinclusion> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Apropertyinclusion entity)
        {
            await _repository.AddAsync(entity);
        }

        public async Task UpdateContactAsync(Apropertyinclusion entity)
        {
            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }

        public async Task<List<Apropertyinclusion>> GetEntityByForeignKeyAsync(int foreignKeyId)
        {
            return await _repository.GetByApropertyIdInclusionAsync(foreignKeyId);
        }
    }
}
