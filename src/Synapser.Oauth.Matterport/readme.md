# Synapsers.Oauth.Matterport - Matterport OAuth Integration for ASP.NET Core & Blazor

Synapsers.Oauth.Matterport is a reusable .NET library that provides a custom OAuth authentication handler for integrating Matterport OAuth into ASP.NET Core and Blazor applications. It is designed to simplify and secure the process of authenticating users with Matterport, supporting both custom and built-in OAuth flows, and enabling seamless integration with ASP.NET Core Identity.

---

## Getting Started

### Register a Matterport Developer Application

Before integrating Synapsers.Oauth.Matterport, you must create an OAuth application in the Matterport Developer Portal:

- Go to the [Matterport Developer Portal](https://developers.matterport.com/).
- Register a new OAuth application.
- Set the **Redirect URI** to match your app, e.g.:
  `https://localhost:7197/signin-matterport`
- Note your **Client ID** and **Client Secret** for use in configuration.

---

## Key Features

- **Custom Matterport OAuth Handler**: Implements a custom OAuth flow for Matterport, allowing full control over the authentication process, including login and callback endpoints.
- **Blazor & ASP.NET Core Support**: Works with both Blazor and traditional ASP.NET Core applications.
- **Secure Token Storage**: Designed to store Matterport access and refresh tokens securely on the user entity, supporting best practices for sensitive data handling.
- **No Session/Correlation Cookie Dependency**: The custom flow does not require ASP.NET Core's default session or correlation cookies, making it suitable for stateless or distributed scenarios.
- **Centralized Configuration**: All Matterport OAuth settings (Client ID, Secret, Scopes, etc.) are managed via `appsettings.json` and strongly-typed options.
- **Extensible**: Easily extendable to support additional claims, events, or custom logic as needed.
- **Compatible with ASP.NET Core Identity**: Integrates with Identity for user management, login, and token persistence.

---

## How It Works

1. **Custom OAuth Flow**: The library provides endpoints and handlers to initiate the Matterport OAuth login, redirect users to Matterport for authentication, and handle the callback to exchange the authorization code for tokens.
2. **Token Management**: After successful authentication, the access and refresh tokens are stored on the user entity (e.g., `ApplicationUser`), along with the token expiration time.
3. **User Management**: If a user does not exist, the handler can create a new user account and associate the Matterport tokens.
4. **Seamless Sign-In**: After token exchange, the user is signed in using ASP.NET Core Identity, and their Matterport tokens are available for use in the application.
5. **Built-in Handler Support**: Optionally, the library can be configured to use the built-in ASP.NET Core OAuth handler for Matterport, with a separate callback path to avoid conflicts with the custom flow.

---

## Typical Usage Scenario

- Add the Synapsers.Oauth.Matterport NuGet package to your ASP.NET Core or Blazor project.
- Configure Matterport OAuth settings in `appsettings.json`.
- Register the custom authentication handler in `Program.cs` using the provided extension methods.
- Extend your Identity user class to include Matterport token fields.
- Use the provided Blazor/Razor pages or build your own UI to initiate login and handle callbacks.
- Securely access Matterport APIs on behalf of authenticated users using the stored tokens.

---

## Example Usage

### 1. Configure Matterport OAuth in `appsettings.json`

```json
"Matterport": {
  "ClientId": "YOUR_CLIENT_ID",
  "ClientSecret": "YOUR_CLIENT_SECRET",
  "Scope": [ "ViewDetails", "ViewPublic" ]
}
```

### 2. Extend Your Identity User

```csharp
using Microsoft.AspNetCore.Identity;
using System;

public class ApplicationUser : IdentityUser
{
    public string? MatterportAccessToken { get; set; }
    public string? MatterportRefreshToken { get; set; }
    public DateTime? MatterportTokenExpires { get; set; }
}
```

### 3. Register the Handler in `Program.cs`

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
    options.CallbackPath = "/signin-matterport-handler"; // Use a unique path for the built-in handler
});
// ...existing code...
```

### 4. Use the Tokens in Your App

After authentication, access tokens are available on your `ApplicationUser` entity:

```csharp
var accessToken = user.MatterportAccessToken;
var refreshToken = user.MatterportRefreshToken;
var expires = user.MatterportTokenExpires;
```

---

## Security Considerations

- **Never commit real secrets** (Client Secret, tokens) to source control.
- For production, use secure secret storage (e.g., Azure Key Vault, environment variables).
- Always use HTTPS in production environments.
- Regularly review and update dependencies to address security vulnerabilities.

---

## Contributing & Support

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## License

MIT License