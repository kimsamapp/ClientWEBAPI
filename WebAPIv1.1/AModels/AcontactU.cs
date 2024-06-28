using System;
using System.Collections.Generic;

namespace WebAPIv1._1.AModels;

public partial class AcontactU
{
    public int AcontactUsId { get; set; }

    public string Name { get; set; }

    public string EmailAddress { get; set; }

    public string ContactUsNumber { get; set; }

    public string MessageContext { get; set; }

    public int? IsStatus { get; set; }

    public DateTime? DateCreated { get; set; }

    public int? AheaderServicesId { get; set; }

    public virtual AheaderService AheaderServices { get; set; }
}
