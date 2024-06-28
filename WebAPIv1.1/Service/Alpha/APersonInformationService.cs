using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class APersonInformationService
    {
        private readonly ARepository<Apersoninformation> _repository;

        public APersonInformationService(ARepository<Apersoninformation> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Apersoninformation>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Apersoninformation> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Apersoninformation entity)
        {
            await _repository.AddAsync(entity);
        }

        //public async Task UpdateContactAsync(ApersonInformation entity)
        //{
        //    await _repository.UpdateAsync(entity);
        //}

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
