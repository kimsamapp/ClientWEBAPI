using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Acontactu
{
    public int AcontactUsId { get; set; }

    public string Name { get; set; }

    public string EmailAddress { get; set; }

    public string ContactUsNumber { get; set; }

    public string MessageContext { get; set; }

    public int? IsStatus { get; set; }

    public DateTime? DateCreated { get; set; }

    public int? AheaderServicesId { get; set; }

    public virtual Aheaderservice AheaderServices { get; set; }
}
