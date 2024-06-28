using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Microsoft.EntityFrameworkCore;

namespace WebAPIv1._1.Extensions
{
    public static class IQueryableExtensions
    {
        public static IQueryable<T> IncludeAll<T>(this IQueryable<T> query) where T : class
        {
            var entityType = typeof(T);
            var navigationProperties = entityType.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .Where(p =>
                    (typeof(IEnumerable<object>).IsAssignableFrom(p.PropertyType) && p.PropertyType != typeof(string)) ||
                    (typeof(object).IsAssignableFrom(p.PropertyType) && p.PropertyType.IsClass && p.PropertyType != typeof(string))
                );

            foreach (var property in navigationProperties)
            {
                query = query.Include(property.Name);
            }

            return query;
        }
    }
}
