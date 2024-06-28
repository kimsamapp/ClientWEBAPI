using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class ContactService
    {
        private readonly ARepository<Afcontact> _repository;

        public ContactService(ARepository<Afcontact> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Afcontact>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Afcontact> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Afcontact entity)
        {
            await _repository.AddAsync(entity);
        }

        //public async Task UpdateContactAsync(Afcontact entity)
        //{
        //    await _repository.UpdateAsync(entity);
        //}

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }
    }


}
