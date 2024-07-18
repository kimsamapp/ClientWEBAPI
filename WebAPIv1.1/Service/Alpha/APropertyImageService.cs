using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.ARepository;
using WebAPIv1._1.MySQLModels;

namespace WebAPIv1._1.Service.Alpha
{
    public class APropertyImageService
    {
        private readonly ARepository<Apropertyimage> _repository;

        public APropertyImageService(ARepository<Apropertyimage> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Apropertyimage>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Apropertyimage> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Apropertyimage entity)
        {
            await _repository.AddAsync(entity);
        }

        public async Task UpdateContactAsync(Apropertyimage entity)
        {
            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
