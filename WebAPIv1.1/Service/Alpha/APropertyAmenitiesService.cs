using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class APropertyAmenitiesService
    {
        private readonly ARepository<Apropertyamenity> _repository;

        public APropertyAmenitiesService(ARepository<Apropertyamenity> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Apropertyamenity>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Apropertyamenity> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Apropertyamenity entity)
        {
            await _repository.AddAsync(entity);
        }

        public async Task UpdateContactAsync(Apropertyamenity entity)
        {
            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }

        public async Task AddEntitiesAsync<T>(IEnumerable<T> entities) where T : class
        {
            await _repository.AddEntitiesInBulkAsync(entities);
        }

        public async Task<List<Apropertyamenity>> GetEntityByForeignKeyAsync(int foreignKeyId)
        {
            return await _repository.GetByApropertyIdAmenityAsync(foreignKeyId);
        }
    }
}
