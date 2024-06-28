using System;
using System.Collections.Generic;

namespace WebAPIv1._1.AModels;

public partial class ApropertyInclusion
{
    public int ApropertyInclusionId { get; set; }

    public int? PropertyId { get; set; }

    public string Name { get; set; }

    public virtual Aproperty Property { get; set; }
}
