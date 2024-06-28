using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class AFLinkService
    {
        private readonly ARepository<Aflink> _repository;

        public AFLinkService(ARepository<Aflink> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Aflink>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Aflink> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Aflink entity)
        {
            await _repository.AddAsync(entity);
        }

        public async Task UpdateContactAsync(Aflink entity)
        {
            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }
}
