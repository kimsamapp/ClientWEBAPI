using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Aheaderservice
{
    public int AheaderServicesId { get; set; }

    public string HeaderName { get; set; }

    public string Description { get; set; }

    public virtual ICollection<Acontactu> Acontactus { get; set; } = new List<Acontactu>();

    public virtual ICollection<Aproperty> Aproperties { get; set; } = new List<Aproperty>();
}
