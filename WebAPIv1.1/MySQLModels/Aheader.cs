using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Aheader
{
    public int AheaderId { get; set; }

    public string HeaderTextMessage { get; set; }

    public string HeaderTextSubMessage { get; set; }
}
