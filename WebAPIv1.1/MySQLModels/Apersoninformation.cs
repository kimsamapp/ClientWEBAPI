using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Apersoninformation
{
    public int PersonId { get; set; }

    public string Firstname { get; set; }

    public string Middlename { get; set; }

    public string Lastname { get; set; }

    public string ContactNumber { get; set; }

    public string EmailAddress { get; set; }

    public virtual ICollection<Auser> Ausers { get; set; } = new List<Auser>();
}
