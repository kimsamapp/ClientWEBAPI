using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class AHeadersService
    {
        private readonly ARepository<Aheader> _repository;

        public AHeadersService(ARepository<Aheader> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Aheader>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Aheader> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Aheader entity)
        {
            await _repository.AddAsync(entity);
        }

        //public async Task UpdateContactAsync(Aheader entity)
        //{
        //    await _repository.UpdateAsync(entity);
        //}

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
