﻿using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.ARepository;

namespace WebAPIv1._1.Service.Alpha
{
    public class APropertyService
    {
        private readonly ARepository<Aproperty> _repository;

        public APropertyService(ARepository<Aproperty> repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Aproperty>> GetAllContactsAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Aproperty> GetContactByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task AddContactAsync(Aproperty entity)
        {
            await _repository.AddAsync(entity);
        }

        public async Task UpdateContactAsync(Aproperty entity)
        {
            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteContactAsync(int id)
        {
            await _repository.DeleteAsync(id);
        }

    }
}