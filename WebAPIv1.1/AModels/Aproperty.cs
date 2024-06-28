using System;
using System.Collections.Generic;

namespace WebAPIv1._1.AModels;

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

    public virtual AheaderService AheaderServices { get; set; }

    public virtual ICollection<ApropertyAmenity> ApropertyAmenities { get; set; } = new List<ApropertyAmenity>();

    public virtual ICollection<ApropertyInclusion> ApropertyInclusions { get; set; } = new List<ApropertyInclusion>();
}
