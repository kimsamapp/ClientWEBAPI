using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using System;
using System.Linq;

public interface IFileService
{
    Task<List<string>> GetAllFilesInFolderAsync(int id);
    Task<string> SaveFileAsync(int id, IFormFile file);
    Task<bool> DeleteFileAsync(int id, string fileName);
    Task<bool> DeleteFolderAsync(int id);
}

public class FileService : IFileService
{
    private readonly string _uploadsPath = Path.Combine(Directory.GetCurrentDirectory(), "Uploads");

    public async Task<List<string>> GetAllFilesInFolderAsync(int id)
    {
        var folderPath = Path.Combine(_uploadsPath, id.ToString());

        if (!Directory.Exists(folderPath))
        {
            throw new DirectoryNotFoundException($"Folder with ID '{id}' not found.");
        }

        var fileNames = Directory.GetFiles(folderPath)
                                .Select(filePath => Path.GetFileName(filePath))
                                .ToList();

        return await Task.FromResult(fileNames);
    }

    public async Task<string> SaveFileAsync(int id, IFormFile file)
    {
        var folderPath = Path.Combine(_uploadsPath, id.ToString());
        Directory.CreateDirectory(folderPath);

        var fileName = $"{Guid.NewGuid().ToString()}";
        var filePath = Path.Combine(folderPath, fileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        return fileName;
    }

    public async Task<bool> DeleteFileAsync(int id, string fileName)
    {
        var filePath = Path.Combine(_uploadsPath, id.ToString(), fileName);

        if (File.Exists(filePath))
        {
            File.Delete(filePath);
            return await Task.FromResult(true);
        }

        return await Task.FromResult(false);
    }

    public async Task<bool> DeleteFolderAsync(int id)
    {
        var folderPath = Path.Combine(_uploadsPath, id.ToString());

        if (Directory.Exists(folderPath))
        {
            Directory.Delete(folderPath, true);
            return await Task.FromResult(true);
        }

        return await Task.FromResult(false);
    }
}
