using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class AHeaderServicesService
    {
        private readonly ARepository<Aheaderservice> _repository;

        public AHeaderServicesService(ARepository<Aheaderservice> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Aheaderservice>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Aheaderservice> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Aheaderservice entity)
        {
            await _repository.AddAsync(entity);
        }

        //public async Task UpdateContactAsync(Aheaderservice entity)
        //{
        //    await _repository.UpdateAsync(entity);
        //}

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
