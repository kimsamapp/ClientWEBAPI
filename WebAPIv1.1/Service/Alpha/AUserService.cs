using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class AUserService
    {
        private readonly ARepository<Auser> _repository;

        public AUserService(ARepository<Auser> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Auser>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Auser> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Auser entity)
        {
            await _repository.AddAsync(entity);
        }

        //public async Task UpdateContactAsync(Auser entity)
        //{
        //    await _repository.UpdateAsync(entity);
        //}

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
