using Microsoft.AspNetCore.Identity;
using System; // Required for DateTime

namespace TestApp.Data
{
    // Add profile data for application users by adding properties to the ApplicationUser class
    public class ApplicationUser : IdentityUser
    {
        // Matterport OAuth tokens
        public string? MatterportAccessToken { get; set; }
        public string? MatterportRefreshToken { get; set; }
        public DateTime? MatterportTokenExpires { get; set; }
    }

}
