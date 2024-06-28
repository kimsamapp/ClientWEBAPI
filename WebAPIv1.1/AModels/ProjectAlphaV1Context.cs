using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace WebAPIv1._1.AModels;

public partial class ProjectAlphaV1Context : DbContext
{
    public ProjectAlphaV1Context()
    {
    }

    public ProjectAlphaV1Context(DbContextOptions<ProjectAlphaV1Context> options)
        : base(options)
    {
    }

    public virtual DbSet<AcontactU> AcontactUs { get; set; }

    public virtual DbSet<Afcontact> Afcontacts { get; set; }

    public virtual DbSet<Aflink> Aflinks { get; set; }

    public virtual DbSet<Afooter> Afooters { get; set; }

    public virtual DbSet<Aheader> Aheaders { get; set; }

    public virtual DbSet<AheaderService> AheaderServices { get; set; }

    public virtual DbSet<ApersonInformation> ApersonInformations { get; set; }

    public virtual DbSet<Aproperty> Aproperties { get; set; }

    public virtual DbSet<ApropertyAmenity> ApropertyAmenities { get; set; }

    public virtual DbSet<ApropertyImage> ApropertyImages { get; set; }

    public virtual DbSet<ApropertyInclusion> ApropertyInclusions { get; set; }

    public virtual DbSet<Auser> Ausers { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=LAPTOP-ACTM7T4C;Database=ProjectAlphaV1;Trusted_Connection=True;MultipleActiveResultSets=true;Encrypt=false");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AcontactU>(entity =>
        {
            entity.HasKey(e => e.AcontactUsId).HasName("PK__AContact__6B4CE5773E14FBE7");

            entity.ToTable("AContactUs");

            entity.Property(e => e.AcontactUsId).HasColumnName("AContactUsId");
            entity.Property(e => e.AheaderServicesId).HasColumnName("AHeaderServicesId");
            entity.Property(e => e.ContactUsNumber)
                .HasMaxLength(250)
                .IsUnicode(false);
            entity.Property(e => e.DateCreated)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(250)
                .IsUnicode(false);
            entity.Property(e => e.MessageContext).IsUnicode(false);
            entity.Property(e => e.Name)
                .HasMaxLength(250)
                .IsUnicode(false);

            entity.HasOne(d => d.AheaderServices).WithMany(p => p.AcontactUs)
                .HasForeignKey(d => d.AheaderServicesId)
                .HasConstraintName("FK__AContactU__AHead__6477ECF3");
        });

        modelBuilder.Entity<Afcontact>(entity =>
        {
            entity.HasKey(e => e.Afcontacts).HasName("PK__AFContac__F209EEC239F1BE77");

            entity.ToTable("AFContacts");

            entity.Property(e => e.Afcontacts).HasColumnName("AFContacts");
            entity.Property(e => e.ContactNumber)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.Name)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.PlatformContact)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Aflink>(entity =>
        {
            entity.HasKey(e => e.AflinksId).HasName("PK__AFLinks__4CF6503C32C3B83C");

            entity.ToTable("AFLinks");

            entity.Property(e => e.AflinksId).HasColumnName("AFLinksId");
            entity.Property(e => e.LinkUrl)
                .HasMaxLength(200)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Afooter>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("AFooter");

            entity.Property(e => e.Address)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.AfooterId)
                .ValueGeneratedOnAdd()
                .HasColumnName("AFooterId");
        });

        modelBuilder.Entity<Aheader>(entity =>
        {
            entity.HasKey(e => e.AheaderId).HasName("PK__AHeader__5ABEF3D113D8B18C");

            entity.ToTable("AHeader");

            entity.Property(e => e.AheaderId).HasColumnName("AHeaderId");
            entity.Property(e => e.HeaderTextMessage)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.HeaderTextSubMessage)
                .HasMaxLength(500)
                .IsUnicode(false);
        });

        modelBuilder.Entity<AheaderService>(entity =>
        {
            entity.HasKey(e => e.AheaderServicesId).HasName("PK__AHeaderS__AC75FFAFB774F7E1");

            entity.ToTable("AHeaderServices");

            entity.Property(e => e.AheaderServicesId).HasColumnName("AHeaderServicesId");
            entity.Property(e => e.Description)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.HeaderName)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ApersonInformation>(entity =>
        {
            entity.HasKey(e => e.PersonId).HasName("PK__APersonI__AA2FFBE5A79D4F54");

            entity.ToTable("APersonInformation");

            entity.Property(e => e.ContactNumber)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.Firstname)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Lastname)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Middlename)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Aproperty>(entity =>
        {
            entity.HasKey(e => e.PropertyId).HasName("PK__APropert__70C9A7356D5CA455");

            entity.ToTable("AProperty");

            entity.Property(e => e.AheaderServicesId).HasColumnName("AHeaderServicesId");
            entity.Property(e => e.DateCreated)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Description).IsUnicode(false);
            entity.Property(e => e.FloorArea).HasColumnType("decimal(16, 2)");
            entity.Property(e => e.Furnishing)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.LocationA).IsUnicode(false);
            entity.Property(e => e.LotArea).HasColumnType("decimal(16, 2)");
            entity.Property(e => e.Name)
                .HasMaxLength(300)
                .IsUnicode(false);
            entity.Property(e => e.PriceAmount).HasColumnType("decimal(16, 2)");
            entity.Property(e => e.PropertyCode)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.AheaderServices).WithMany(p => p.Aproperties)
                .HasForeignKey(d => d.AheaderServicesId)
                .HasConstraintName("FK__AProperty__AHead__571DF1D5");
        });

        modelBuilder.Entity<ApropertyAmenity>(entity =>
        {
            entity.HasKey(e => e.ApropertyAmenityId).HasName("PK__APropert__FE7AB770F59A7596");

            entity.ToTable("APropertyAmenities");

            entity.Property(e => e.ApropertyAmenityId).HasColumnName("APropertyAmenityId");
            entity.Property(e => e.Name).IsUnicode(false);

            entity.HasOne(d => d.Property).WithMany(p => p.ApropertyAmenities)
                .HasForeignKey(d => d.PropertyId)
                .HasConstraintName("FK__AProperty__Prope__5FB337D6");
        });

        modelBuilder.Entity<ApropertyImage>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("APropertyImage");

            entity.Property(e => e.ApropertyImageId)
                .ValueGeneratedOnAdd()
                .HasColumnName("APropertyImageId");
            entity.Property(e => e.FileName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.FilePath)
                .HasMaxLength(200)
                .IsUnicode(false);

            entity.HasOne(d => d.Property).WithMany()
                .HasForeignKey(d => d.PropertyId)
                .HasConstraintName("FK__AProperty__Prope__5CD6CB2B");
        });

        modelBuilder.Entity<ApropertyInclusion>(entity =>
        {
            entity.HasKey(e => e.ApropertyInclusionId).HasName("PK__APropert__E0D87AD7AE532AED");

            entity.ToTable("APropertyInclusions");

            entity.Property(e => e.ApropertyInclusionId).HasColumnName("APropertyInclusionId");
            entity.Property(e => e.Name).IsUnicode(false);

            entity.HasOne(d => d.Property).WithMany(p => p.ApropertyInclusions)
                .HasForeignKey(d => d.PropertyId)
                .HasConstraintName("FK__AProperty__Prope__5AEE82B9");
        });

        modelBuilder.Entity<Auser>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__AUser__1788CC4C3D88D52E");

            entity.ToTable("AUser");

            entity.Property(e => e.DateCreated)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.PasswordHash).IsUnicode(false);
            entity.Property(e => e.PasswordSalt).IsUnicode(false);
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Person).WithMany(p => p.Ausers)
                .HasForeignKey(d => d.PersonId)
                .HasConstraintName("FK__AUser__PersonId__3A81B327");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
