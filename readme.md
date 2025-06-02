<p align="center">
  <img src="content/srs-full-logo.webp" alt="Synapsers - Matterport OAuth for ASP.NET Core & Blazor" style="max-width: 100%; height: auto;">
</p>


# Synapsers.Oauth.Matterport - Matterport OAuth Integration for ASP.NET Core & Blazor

<p align="center">
  <a href="https://github.com/SynapeResearchSystemsCorp/Synapsers.Oauth.Matterport/stargazers">
    <img src="https://img.shields.io/github/stars/SynapeResearchSystemsCorp/Synapsers.Oauth.Matterport" alt="GitHub Repo stars">
  </a>
  <a href="https://github.com/SynapeResearchSystemsCorp/Synapsers.Oauth.Matterport/commits/main">
    <img src="https://img.shields.io/github/last-commit/SynapeResearchSystemsCorp/Synapsers.Oauth.Matterport" alt="GitHub last commit">
  </a>
  <a href="https://github.com/SynapeResearchSystemsCorp/Synapsers.Oauth.Matterport/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/SynapeResearchSystemsCorp/Synapsers.Oauth.Matterport" alt="Contributors">
  </a>
  <a href="https://www.nuget.org/packages/Synapsers.Oauth.Matterport/">
    <img src="https://img.shields.io/nuget/v/Synapsers.Oauth.Matterport.svg" alt="NuGet version">
  </a>
  <a href="https://www.nuget.org/packages/Synapsers.Oauth.Matterport/">
    <img src="https://img.shields.io/nuget/dt/Synapsers.Oauth.Matterport.svg" alt="NuGet downloads">
  </a>
</p>


# Overview

**Synapsers.Oauth.Matterport** is a reusable .NET library for integrating Matterport OAuth authentication into ASP.NET Core and Blazor applications. It provides a secure, extensible, and production-ready solution for handling Matterport OAuth flows, token storage, and user management, with or without ASP.NET Core Identity.

---

## Features

- **Custom Matterport OAuth Handler**: Full control over the OAuth flow, including login and callback endpoints.
- **Blazor & ASP.NET Core Support**: Works with both Blazor and traditional ASP.NET Core apps.
- **Secure Token Storage**: Store Matterport access/refresh tokens on the user entity.
- **No Session/Correlation Cookie Dependency**: Stateless custom flow for distributed/cloud scenarios.
- **Centralized Configuration**: All settings via `appsettings.json` and strongly-typed options.
- **Extensible**: Add custom claims, events, or logic as needed.
- **Compatible with ASP.NET Core Identity**: Integrates with Identity for user management and token persistence.

---

## Quick Start

### 1. Create a Matterport Developer Application

- Go to the [Matterport Developer Portal](https://developers.matterport.com/).
- Register a new OAuth application.
- Set the **Redirect URI** to match your app, e.g.:
  `https://localhost:7197/signin-matterport`
- Note your **Client ID** and **Client Secret** for use in configuration.

  **Example:**

  ![Matterport App Registration Screenshot](/content/MP-AppRegistration.png)


### 2. Install the Library

Add the package to your project (NuGet coming soon):

```sh
# Example (when published)
dotnet add package Synapsers.Oauth
```

### 3. Configure Matterport OAuth in `appsettings.json`

```json
"Matterport": {
  "ClientId": "YOUR_CLIENT_ID",
  "ClientSecret": "YOUR_CLIENT_SECRET",
  "Scope": [ "ViewDetails", "ViewPublic" ]
}
```

### 4. Extend Your Identity User (if using Identity)

```csharp
public class ApplicationUser : IdentityUser
{
    public string? MatterportAccessToken { get; set; }
    public string? MatterportRefreshToken { get; set; }
    public DateTime? MatterportTokenExpires { get; set; }
}
```

### 5. Register the Handler in `Program.cs`

```csharp
using Synapsers.Oauth.Matterport;
// ...existing code...
var matterportSection = builder.Configuration.GetSection("Matterport");
builder.Services.Configure<MatterportAppOptions>(matterportSection);
var matterportOptions = matterportSection.Get<MatterportAppOptions>() ?? new MatterportAppOptions();

builder.Services.AddAuthentication(options =>
{
    options.DefaultScheme = "Matterport";
})
.AddMatterport(options =>
{
    options.ClientId = matterportOptions.ClientId;
    options.ClientSecret = matterportOptions.ClientSecret;
    options.Scope.Clear();
    foreach (var scope in matterportOptions.Scope ?? Array.Empty<string>())
        options.Scope.Add(scope);
});
// ...existing code...
```

### 6. Implement the Login and Callback UI

- Use Blazor/Razor pages to start the OAuth flow and handle the callback.
- On callback, exchange the code for tokens, store them on the user, and sign in.

---

## Example: TestApp

The `src/TestApp` project demonstrates a full integration:

- **Custom login page**: `/Account/StartMatterportLogin` (Blazor)
- **Callback handler**: `/signin-matterport` (Blazor)
- **Token storage**: On `ApplicationUser` entity
- **Identity integration**: Uses ASP.NET Core Identity for user management
- **Configuration**: All settings in `appsettings.json`

See [`src/TestApp/readme.md`](src/TestApp/readme.md) for a step-by-step guide.

---

## Security Notes

- Never commit real secrets to source control.
- For production, use secure secret storage (Azure Key Vault, environment variables, etc).
- Always use HTTPS in production.

---

## Contributing & Support

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## License

MIT License
