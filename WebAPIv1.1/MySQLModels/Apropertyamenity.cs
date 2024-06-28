using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Apropertyamenity
{
    public int ApropertyAmenityId { get; set; }

    public int? PropertyId { get; set; }

    public string Name { get; set; }

    public virtual Aproperty Property { get; set; }
}
