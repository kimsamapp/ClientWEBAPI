using System;
using System.Collections.Generic;

namespace WebAPIv1._1.AModels;

public partial class AheaderService
{
    public int AheaderServicesId { get; set; }

    public string HeaderName { get; set; }

    public string Description { get; set; }

    public virtual ICollection<AcontactU> AcontactUs { get; set; } = new List<AcontactU>();

    public virtual ICollection<Aproperty> Aproperties { get; set; } = new List<Aproperty>();
}
