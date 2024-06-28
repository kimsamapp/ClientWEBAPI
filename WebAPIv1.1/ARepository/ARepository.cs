using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using WebAPIv1._1.MySQLModels;
using WebAPIv1._1.Extensions;
using System.Linq;

namespace WebAPIv1._1.ARepository
{
    public class ARepository<T> where T : class
    {
        private readonly ProjectAlphaV1Context _context;
        private readonly DbSet<T> _dbSet;
        public ARepository(ProjectAlphaV1Context context) 
        {
            _context = context;
            _dbSet = _context.Set<T>();
        }

        public async Task<IEnumerable<T>> GetAllAsync()
        {
            return await _dbSet.IncludeAll().ToListAsync();
        }

        public async Task<T> GetByIdAsync(object id)
        {
            return await _dbSet.FindAsync(id);
        }

        public async Task AddAsync(T entity)
        {
            await _dbSet.AddAsync(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(T entity)
        {
            _dbSet.Attach(entity);
            _context.Entry(entity).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(object id)
        {
            T entity = await _dbSet.FindAsync(id);
            if (entity != null)
            {
                _dbSet.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task AddEntitiesInBulkAsync<T>(IEnumerable<T> entities) where T : class
        {
            await _context.Set<T>().AddRangeAsync(entities);
            await _context.SaveChangesAsync();
        }

        public async Task<List<TEntity>> GetByForeignKeyAsync<TForeignEntity, TEntity>(int foreignKeyId)
            where TEntity : class
            where TForeignEntity : class
        {
            var foreignKeyName = $"{typeof(TForeignEntity).Name}Id";

            var entities = await _context.Set<TEntity>()
                .Where(e => EF.Property<int>(e, foreignKeyName) == foreignKeyId)
                .ToListAsync();

            return entities;

        }

        public async Task<List<Apropertyinclusion>> GetByApropertyIdInclusionAsync(int apropertyId)
        {
            var entities = await _context.Apropertyinclusions
                .Where(ai => ai.PropertyId == apropertyId)
                .ToListAsync();

            return entities;
        }

        public async Task<List<Apropertyamenity>> GetByApropertyIdAmenityAsync(int apropertyId)
        {
            var entities = await _context.Apropertyamenities
                .Where(ai => ai.PropertyId == apropertyId)
                .ToListAsync();

            return entities;
        }

    }
}
