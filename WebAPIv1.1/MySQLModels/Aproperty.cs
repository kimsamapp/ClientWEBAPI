using System;
using System.Collections.Generic;

namespace WebAPIv1._1.MySQLModels;

public partial class Aproperty
{
    public int PropertyId { get; set; }

    public string PropertyCode { get; set; }

    public string Name { get; set; }

    public string Description { get; set; }

    public int? AheaderServicesId { get; set; }

    public string LocationA { get; set; }

    public decimal? PriceAmount { get; set; }

    public int? BedRooms { get; set; }

    public int? BathRooms { get; set; }

    public decimal? FloorArea { get; set; }

    public decimal? LotArea { get; set; }

    public int? Garage { get; set; }

    public string Furnishing { get; set; }

    public DateTime? DateCreated { get; set; }

    public int? IsStatus { get; set; }

    public int? IsActive { get; set; }

    public virtual Aheaderservice AheaderServices { get; set; }

    public virtual ICollection<Apropertyamenity> Apropertyamenities { get; set; } = new List<Apropertyamenity>();

    public virtual ICollection<Apropertyimage> Apropertyimages { get; set; } = new List<Apropertyimage>();

    public virtual ICollection<Apropertyinclusion> Apropertyinclusions { get; set; } = new List<Apropertyinclusion>();
}
