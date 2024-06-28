using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class AContactUsService
    {
        private readonly ARepository<Acontactu> _repository;
        public AContactUsService(ARepository<Acontactu> repository) 
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Acontactu>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Acontactu> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Acontactu contact)
        {
            await _repository.AddAsync(contact);
        }

        public async Task UpdateContactAsync(Acontactu contact)
        {
            await _repository.UpdateAsync(contact);
        }

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
