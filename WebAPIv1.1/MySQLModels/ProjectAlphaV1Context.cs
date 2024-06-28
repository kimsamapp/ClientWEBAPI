using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace WebAPIv1._1.MySQLModels;

public partial class ProjectAlphaV1Context : DbContext
{
    public ProjectAlphaV1Context()
    {
    }

    public ProjectAlphaV1Context(DbContextOptions<ProjectAlphaV1Context> options)
        : base(options)
    {
    }

    public virtual DbSet<Acontactu> Acontactus { get; set; }

    public virtual DbSet<Afcontact> Afcontacts { get; set; }

    public virtual DbSet<Aflink> Aflinks { get; set; }

    public virtual DbSet<Afooter> Afooters { get; set; }

    public virtual DbSet<Aheader> Aheaders { get; set; }

    public virtual DbSet<Aheaderservice> Aheaderservices { get; set; }

    public virtual DbSet<Apersoninformation> Apersoninformations { get; set; }

    public virtual DbSet<Aproperty> Aproperties { get; set; }

    public virtual DbSet<Apropertyamenity> Apropertyamenities { get; set; }

    public virtual DbSet<Apropertyimage> Apropertyimages { get; set; }

    public virtual DbSet<Apropertyinclusion> Apropertyinclusions { get; set; }

    public virtual DbSet<Auser> Ausers { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseMySQL("Server=localhost;Port=3306;Database=ProjectAlphaV1;Uid=root;Pwd=;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Acontactu>(entity =>
        {
            entity.HasKey(e => e.AcontactUsId).HasName("PRIMARY");

            entity.ToTable("acontactus");

            entity.HasIndex(e => e.AheaderServicesId, "FK_AContactUs_AHeaderServicesId");

            entity.Property(e => e.AcontactUsId)
                .HasColumnType("int(11)")
                .HasColumnName("AContactUsId");
            entity.Property(e => e.AheaderServicesId)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)")
                .HasColumnName("AHeaderServicesId");
            entity.Property(e => e.ContactUsNumber)
                .HasMaxLength(250)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.DateCreated)
                .HasDefaultValueSql("'current_timestamp()'")
                .HasColumnType("datetime");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(250)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.IsStatus)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");
            entity.Property(e => e.MessageContext)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("text");
            entity.Property(e => e.Name)
                .HasMaxLength(250)
                .HasDefaultValueSql("'NULL'");

            entity.HasOne(d => d.AheaderServices).WithMany(p => p.Acontactus)
                .HasForeignKey(d => d.AheaderServicesId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("FK_AContactUs_AHeaderServicesId");
        });

        modelBuilder.Entity<Afcontact>(entity =>
        {
            entity.HasKey(e => e.AfcontactsId).HasName("PRIMARY");

            entity.ToTable("afcontacts");

            entity.Property(e => e.AfcontactsId)
                .HasColumnType("int(11)")
                .HasColumnName("AFContactsId");
            entity.Property(e => e.ContactNumber)
                .HasMaxLength(20)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(200)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.Name)
                .HasMaxLength(150)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.PlatformContact)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
        });

        modelBuilder.Entity<Aflink>(entity =>
        {
            entity.HasKey(e => e.AflinksId).HasName("PRIMARY");

            entity.ToTable("aflinks");

            entity.Property(e => e.AflinksId)
                .HasColumnType("int(11)")
                .HasColumnName("AFLinksId");
            entity.Property(e => e.LinkUrl)
                .HasMaxLength(200)
                .HasDefaultValueSql("'NULL'");
        });

        modelBuilder.Entity<Afooter>(entity =>
        {
            entity.HasKey(e => e.AfooterId).HasName("PRIMARY");

            entity.ToTable("afooter");

            entity.Property(e => e.AfooterId)
                .HasColumnType("int(11)")
                .HasColumnName("AFooterId");
            entity.Property(e => e.Address)
                .HasMaxLength(500)
                .HasDefaultValueSql("'NULL'");
        });

        modelBuilder.Entity<Aheader>(entity =>
        {
            entity.HasKey(e => e.AheaderId).HasName("PRIMARY");

            entity.ToTable("aheader");

            entity.Property(e => e.AheaderId)
                .HasColumnType("int(11)")
                .HasColumnName("AHeaderId");
            entity.Property(e => e.HeaderTextMessage)
                .HasMaxLength(500)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.HeaderTextSubMessage)
                .HasMaxLength(500)
                .HasDefaultValueSql("'NULL'");
        });

        modelBuilder.Entity<Aheaderservice>(entity =>
        {
            entity.HasKey(e => e.AheaderServicesId).HasName("PRIMARY");

            entity.ToTable("aheaderservices");

            entity.Property(e => e.AheaderServicesId)
                .HasColumnType("int(11)")
                .HasColumnName("AHeaderServicesId");
            entity.Property(e => e.Description)
                .HasMaxLength(500)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.HeaderName)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
        });

        modelBuilder.Entity<Apersoninformation>(entity =>
        {
            entity.HasKey(e => e.PersonId).HasName("PRIMARY");

            entity.ToTable("apersoninformation");

            entity.Property(e => e.PersonId).HasColumnType("int(11)");
            entity.Property(e => e.ContactNumber)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(200)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.Firstname)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.Lastname)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.Middlename)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
        });

        modelBuilder.Entity<Aproperty>(entity =>
        {
            entity.HasKey(e => e.PropertyId).HasName("PRIMARY");

            entity.ToTable("aproperty");

            entity.HasIndex(e => e.AheaderServicesId, "FK_AProperty_AHeaderServicesId");

            entity.Property(e => e.PropertyId).HasColumnType("int(11)");
            entity.Property(e => e.AheaderServicesId)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)")
                .HasColumnName("AHeaderServicesId");
            entity.Property(e => e.BathRooms)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");
            entity.Property(e => e.BedRooms)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");
            entity.Property(e => e.DateCreated)
                .HasDefaultValueSql("'current_timestamp()'")
                .HasColumnType("datetime");
            entity.Property(e => e.Description)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("text");
            entity.Property(e => e.FloorArea)
                .HasPrecision(16)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.Furnishing)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.Garage)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");
            entity.Property(e => e.IsStatus)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");
            entity.Property(e => e.LocationA)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("text");
            entity.Property(e => e.LotArea)
                .HasPrecision(16)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.Name)
                .HasMaxLength(300)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.PriceAmount)
                .HasPrecision(16)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.PropertyCode)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");

            entity.HasOne(d => d.AheaderServices).WithMany(p => p.Aproperties)
                .HasForeignKey(d => d.AheaderServicesId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("aproperty_ibfk_1");
        });

        modelBuilder.Entity<Apropertyamenity>(entity =>
        {
            entity.HasKey(e => e.ApropertyAmenityId).HasName("PRIMARY");

            entity.ToTable("apropertyamenities");

            entity.HasIndex(e => e.PropertyId, "FK_APropertyAmenities_PropertyId");

            entity.Property(e => e.ApropertyAmenityId)
                .HasColumnType("int(11)")
                .HasColumnName("APropertyAmenityId");
            entity.Property(e => e.Name)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("text");
            entity.Property(e => e.PropertyId)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");

            entity.HasOne(d => d.Property).WithMany(p => p.Apropertyamenities)
                .HasForeignKey(d => d.PropertyId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("apropertyamenities_ibfk_1");
        });

        modelBuilder.Entity<Apropertyimage>(entity =>
        {
            entity.HasKey(e => e.ApropertyImageId).HasName("PRIMARY");

            entity.ToTable("apropertyimage");

            entity.HasIndex(e => e.PropertyId, "FK_APropertyImage_PropertyId");

            entity.Property(e => e.ApropertyImageId)
                .HasColumnType("int(11)")
                .HasColumnName("APropertyImageId");
            entity.Property(e => e.FileBase64Name).HasDefaultValueSql("'NULL'");
            entity.Property(e => e.FileName)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.FilePath)
                .HasMaxLength(200)
                .HasDefaultValueSql("'NULL'");
            entity.Property(e => e.FileSize)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("bigint(20)");
            entity.Property(e => e.PropertyId)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");

            entity.HasOne(d => d.Property).WithMany(p => p.Apropertyimages)
                .HasForeignKey(d => d.PropertyId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("apropertyimage_ibfk_1");
        });

        modelBuilder.Entity<Apropertyinclusion>(entity =>
        {
            entity.HasKey(e => e.ApropertyInclusionId).HasName("PRIMARY");

            entity.ToTable("apropertyinclusions");

            entity.HasIndex(e => e.PropertyId, "FK_APropertyInclusions_PropertyId");

            entity.Property(e => e.ApropertyInclusionId)
                .HasColumnType("int(11)")
                .HasColumnName("APropertyInclusionId");
            entity.Property(e => e.Name)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("text");
            entity.Property(e => e.PropertyId)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");

            entity.HasOne(d => d.Property).WithMany(p => p.Apropertyinclusions)
                .HasForeignKey(d => d.PropertyId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("apropertyinclusions_ibfk_1");
        });

        modelBuilder.Entity<Auser>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PRIMARY");

            entity.ToTable("auser");

            entity.HasIndex(e => e.PersonId, "FK_AUser_PersonId");

            entity.Property(e => e.UserId).HasColumnType("int(11)");
            entity.Property(e => e.DateCreated)
                .HasDefaultValueSql("'current_timestamp()'")
                .HasColumnType("datetime");
            entity.Property(e => e.PasswordHash).HasDefaultValueSql("'NULL'");
            entity.Property(e => e.PasswordSalt).HasDefaultValueSql("'NULL'");
            entity.Property(e => e.PersonId)
                .HasDefaultValueSql("'NULL'")
                .HasColumnType("int(11)");
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .HasDefaultValueSql("'NULL'");

            entity.HasOne(d => d.Person).WithMany(p => p.Ausers)
                .HasForeignKey(d => d.PersonId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("auser_ibfk_1");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
