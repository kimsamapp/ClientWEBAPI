using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class AFooterService
    {
        private readonly ARepository<Afooter> _repository;

        public AFooterService(ARepository<Afooter> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Afooter>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Afooter> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Afooter entity)
        {
            await _repository.AddAsync(entity);
        }

        //public async Task UpdateContactAsync(Afooter entity)
        //{
        //    await _repository.UpdateAsync(entity);
        //}

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
