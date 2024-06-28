using Microsoft.AspNetCore.Http;

namespace WebAPIv1._1
{
    public class ImageUploadModel
    {
        public IFormFile File { get; set; }
    }
}
