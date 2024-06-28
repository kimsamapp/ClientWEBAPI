using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;
using WebAPIv1._1.Service.Alpha;
using System.IO;

namespace WebAPIv1._1.Controllers.Alpha.External
{
    [Route("api/[controller]")]
    [ApiController]
    public class FileController : ControllerBase
    {
        private readonly IFileService _fileService;
        private readonly string _uploadsPath = Path.Combine(Directory.GetCurrentDirectory(), "Uploads");

        public FileController(IFileService fileService)
        {
            _fileService = fileService;
        }

        // GET: api/files/{id}/getAllFilesInFolder
        [HttpGet("{id}/getAllFilesInFolder")]
        public async Task<ActionResult<List<string>>> GetAllFilesInFolder(int id)
        {
            try
            {
                var fileNames = await _fileService.GetAllFilesInFolderAsync(id);
                return Ok(fileNames);
            }
            catch (DirectoryNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // POST: api/files/{id}/upload
        [HttpPost("{id}/upload")]
        public async Task<ActionResult<string>> UploadFile(int id, IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return BadRequest("No file uploaded or file is empty.");
                }

                var fileName = await _fileService.SaveFileAsync(id, file);
                return Ok(fileName);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // DELETE: api/files/{id}/{fileName}
        [HttpDelete("{id}/{fileName}")]
        public async Task<ActionResult> DeleteFile(int id, string fileName)
        {
            try
            {
                var result = await _fileService.DeleteFileAsync(id, fileName);
                if (result)
                {
                    return Ok(fileName);
                }
                else
                {
                    return NotFound($"File '{fileName}' not found in folder with ID '{id}'.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // DELETE: api/files/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteFolder(int id)
        {
            try
            {
                var result = await _fileService.DeleteFolderAsync(id);
                if (result)
                {
                    return NoContent();
                }
                else
                {
                    return NotFound($"Folder with ID '{id}' not found.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("{id}/{fileName}")]
        public IActionResult GetImage(int id, string fileName)
        {
            var folderPath = Path.Combine(_uploadsPath, id.ToString());

            if (!Directory.Exists(folderPath))
            {
                return NotFound($"Folder with ID '{id}' not found.");
            }

            var filePath = Path.Combine(folderPath, fileName);

            if (!System.IO.File.Exists(filePath))
            {
                return NotFound($"File '{fileName}' not found in folder '{id}'.");
            }

            var fileExtension = Path.GetExtension(filePath).ToLowerInvariant();
            var mimeType = GetMimeType(fileExtension);

            return PhysicalFile(filePath, mimeType);
        }

        private string GetMimeType(string fileExtension)
        {
            return fileExtension switch
            {
                ".jpg" or ".jpeg" => "image/jpeg",
                ".png" => "image/png",
                ".gif" => "image/gif",
                ".bmp" => "image/bmp",
                ".tiff" => "image/tiff",
                _ => "application/octet-stream",
            };
        }
    }
}
