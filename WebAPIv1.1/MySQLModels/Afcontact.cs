using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Afcontact
{
    public int AfcontactsId { get; set; }

    public string Name { get; set; }

    public string EmailAddress { get; set; }

    public string ContactNumber { get; set; }

    public string PlatformContact { get; set; }
}
