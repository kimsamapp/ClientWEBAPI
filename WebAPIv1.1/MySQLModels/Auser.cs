﻿using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Auser
{
    public int UserId { get; set; }

    public string Username { get; set; }

    public string PasswordHash { get; set; }

    public string PasswordSalt { get; set; }

    public DateTime? DateCreated { get; set; }

    public int? PersonId { get; set; }

    public virtual Apersoninformation Person { get; set; }
}
