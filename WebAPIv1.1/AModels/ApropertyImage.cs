using System;
using System.Collections.Generic;

namespace WebAPIv1._1.AModels;

public partial class ApropertyImage
{
    public int ApropertyImageId { get; set; }

    public int? PropertyId { get; set; }

    public string FileName { get; set; }

    public string FileBase64Name { get; set; }

    public string FilePath { get; set; }

    public long? FileSize { get; set; }

    public virtual Aproperty Property { get; set; }
}
