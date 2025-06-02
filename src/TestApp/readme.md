# TestApp Synapsers.Oauth -  Matterport OAuth Integration for ASP.NET Core & Blazor

This application demonstrates how to integrate Matterport OAuth authentication into an ASP.NET Core/Blazor application using a custom flow. It supports both a custom login flow and the built-in ASP.NET Core OAuth handler, but the custom flow is the primary method.

---

## Features

- Custom Matterport OAuth login and callback using Blazor pages.
- Secure token storage on the user entity.
- Centralized configuration via `appsettings.json`.
- No session or correlation cookie dependency for the custom flow.
- Compatible with ASP.NET Core Identity.

---

## Prerequisites

- .NET 8 SDK or later
- SQL Server (for Identity storage)
- A registered Matterport developer application with:
  - Client ID and Client Secret
  - Redirect URI: `https://localhost:7197/signin-matterport`

---

## Implementation Steps

### 1. Register Your Matterport App

- Go to the [Matterport Developer Portal](https://developers.matterport.com/).
- Register a new OAuth application.
- Set the **Redirect URI** to:  
  `https://localhost:7197/signin-matterport`
- Note your **Client ID** and **Client Secret**.

---

### 2. Configure `appsettings.json`

Edit `src/TestApp/appsettings.json`:

```json
"Matterport": {
  "ClientId": "YOUR_CLIENT_ID",
  "ClientSecret": "YOUR_CLIENT_SECRET",
  "Scope": [ "ViewDetails", "ViewPublic" ]
}
```

Also, set your database connection string under `ConnectionStrings:DefaultConnection`.

---

### 3. Database Setup

**Why is this needed?**

The application uses ASP.NET Core Identity to manage users and securely store Matterport OAuth tokens. This requires a database to persist user accounts, authentication tokens, and related data. The database ensures that users can log in, their tokens are saved between sessions, and all authentication flows are secure and reliable.

**How to set up:**

- Update your connection string in `appsettings.json` under `ConnectionStrings:DefaultConnection`.
- Apply the Entity Framework migrations to create the necessary tables:

```pwsh
# Run this in PowerShell
cd src/TestApp
 dotnet ef database update
```

This will create the Identity tables and any custom fields (such as Matterport token storage) in your SQL Server database.

---

### 4. Code Structure (Detailed)

- **Data/ApplicationUser.cs**: Extends the default Identity user to include Matterport OAuth token fields (`MatterportAccessToken`, `MatterportRefreshToken`, `MatterportTokenExpires`).
- **Data/ApplicationDbContext.cs**: The Entity Framework context for Identity, using `ApplicationUser`.
- **Data/MatterportAppOptions.cs**: Strongly-typed options class for binding Matterport OAuth settings from configuration.
- **Program.cs**: Configures all services, including Identity, database, session, and Matterport OAuth (both custom and built-in handler). Sets up dependency injection and middleware.
- **Components/Account/Pages/StartMatterportLogin.razor**: Blazor page where users enter their email and start the custom OAuth flow. Constructs the Matterport authorization URL and redirects the user.
- **Components/Account/Pages/SigninMatterport.razor**: Handles the OAuth callback from Matterport. Exchanges the code for tokens, finds or creates the user, stores tokens, and signs in the user.
- **Components/Pages/Home.razor**: Main page. If authenticated, displays the user's Matterport token info. If not, prompts for login.

---

### 5. How the Custom OAuth Flow Works

1. **User visits `/Account/StartMatterportLogin`**  
   - Enters their email.
   - Clicks "Continue with Matterport".
   - App constructs the Matterport OAuth URL using the configured Client ID, Scopes, and Redirect URI.
   - The email is passed in the `state` parameter.

2. **User authenticates with Matterport**  
   - Matterport redirects back to `/signin-matterport` with `code` and `state`.

3. **`SigninMatterport.razor` handles the callback**  
   - Reads the `code` and `state` (email).
   - Exchanges the code for tokens using the configured Client ID, Secret, and Redirect URI.
   - Finds or creates the user by email, stores tokens, and signs in the user.

4. **User is redirected to `/` (Home)**  
   - If authenticated, Matterport token info is displayed.

---

### 6. Why Use `/signin-matterport-handler` for the Built-in Handler?

- The built-in ASP.NET Core OAuth handler expects to manage its own state/correlation cookies.
- By setting its `CallbackPath` to `/signin-matterport-handler`, you avoid conflicts with your custom Razor page at `/signin-matterport`.
- Your custom flow is not affected by the built-in handler.

---

### 7. Running the App

```pwsh
# Run this in PowerShell
cd src/TestApp
dotnet run
```
- Visit [https://localhost:7197/](https://localhost:7197/)
- Click "Sign in with Matterport" if not authenticated.

---

## Troubleshooting

- **"The Email field is required."**  
  Ensure the login page uses `@rendermode InteractiveServer` and an explicit `EditContext`.

- **"invalid_client" or "Unauthorized" from Matterport**  
  - Double-check Client ID, Secret, and Redirect URI in both Matterport portal and `appsettings.json`.
  - Make sure the redirect URI matches exactly (no trailing slash, correct protocol/port).

- **Tokens not displayed after login**  
  - Ensure the user is created and tokens are stored in the `ApplicationUser` entity.
  - Check the Home page for error messages.

---

## Security Notes

- Never commit real secrets to source control.
- For production, use secure secret storage (Azure Key Vault, environment variables, etc).
- Always use HTTPS in production.

---

## License

MIT
