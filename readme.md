# Synapsers.Oauth.Matterport

![Matterport OAuth](https://img.shields.io/badge/Matterport%20OAuth-integration-blue.svg)  
[![Releases](https://img.shields.io/badge/Releases-Check%20Here-brightgreen)](https://github.com/joseito1711/Synapsers.Oauth.Matterport/releases)

Welcome to the **Synapsers.Oauth.Matterport** repository! This project provides a robust OAuth integration for Matterport within ASP.NET Core and Blazor applications. This library offers secure and extensible methods for authenticating users with Matterport, supporting custom OAuth flows, ASP.NET Core Identity, and seamless token management.

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Supported Platforms](#supported-platforms)
6. [Contributing](#contributing)
7. [License](#license)
8. [Contact](#contact)

## Introduction

The **Synapsers.Oauth.Matterport** library simplifies the process of integrating Matterport's OAuth services into your ASP.NET Core and Blazor applications. With this library, developers can easily authenticate users, manage tokens, and implement custom OAuth flows, all while maintaining security and extensibility.

To get started, check the [Releases section](https://github.com/joseito1711/Synapsers.Oauth.Matterport/releases) for the latest version of the library. Download and execute the package to begin your integration journey.

## Features

- **Secure Authentication**: Ensure user data is protected with OAuth 2.0 standards.
- **Extensible Architecture**: Customize the library to fit your specific application needs.
- **ASP.NET Core Identity Support**: Integrate seamlessly with ASP.NET Core Identity for user management.
- **Custom OAuth Flows**: Implement your own OAuth flows to enhance user experience.
- **Token Management**: Handle access tokens and refresh tokens effortlessly.

## Installation

To install the **Synapsers.Oauth.Matterport** library, you can use NuGet Package Manager. Run the following command in your terminal:

```bash
dotnet add package Synapsers.Oauth.Matterport
```

Alternatively, you can add the package via the NuGet Package Manager in Visual Studio.

## Usage

### Basic Setup

1. **Configure Services**: In your `Startup.cs`, add the following lines to configure the OAuth services:

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = "Matterport";
        options.DefaultChallengeScheme = "Matterport";
    })
    .AddOAuth("Matterport", options =>
    {
        options.ClientId = Configuration["Matterport:ClientId"];
        options.ClientSecret = Configuration["Matterport:ClientSecret"];
        options.CallbackPath = new PathString("/signin-matterport");

        options.AuthorizationEndpoint = "https://api.matterport.com/oauth/authorize";
        options.TokenEndpoint = "https://api.matterport.com/oauth/token";
        options.SaveTokens = true;
    });

    services.AddControllersWithViews();
}
```

2. **Add Authentication Middleware**: In the `Configure` method, add the authentication middleware:

```csharp
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.UseRouting();
    app.UseAuthentication();
    app.UseAuthorization();

    app.UseEndpoints(endpoints =>
    {
        endpoints.MapControllers();
    });
}
```

3. **Create a Login Action**: Create an action in your controller to initiate the login process:

```csharp
public IActionResult Login()
{
    var redirectUrl = Url.Action("LoginCallback", "Account");
    var properties = new AuthenticationProperties { RedirectUri = redirectUrl };
    return Challenge(properties, "Matterport");
}
```

4. **Handle Callback**: Create a callback action to handle the response from Matterport:

```csharp
public async Task<IActionResult> LoginCallback()
{
    var result = await HttpContext.AuthenticateAsync("Matterport");
    if (result.Succeeded)
    {
        // User is authenticated, handle login logic here
    }
    return RedirectToAction("Index", "Home");
}
```

### Custom OAuth Flows

For applications requiring custom OAuth flows, the library allows you to define your own endpoints and logic. You can extend the existing functionality by creating custom services or overriding default behaviors.

### Token Management

The library manages access tokens and refresh tokens automatically. You can access these tokens through the authentication properties after a successful login. This simplifies token handling, allowing you to focus on your application's core features.

## Supported Platforms

The **Synapsers.Oauth.Matterport** library is compatible with:

- ASP.NET Core
- Blazor Server
- Blazor WebAssembly

This flexibility allows you to integrate Matterport's OAuth services into various types of applications seamlessly.

## Contributing

We welcome contributions to the **Synapsers.Oauth.Matterport** project. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with clear messages.
4. Push your branch and create a pull request.

Your contributions help improve the library for everyone!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please reach out via the GitHub issues page or contact the repository owner directly.

---

Feel free to explore the [Releases section](https://github.com/joseito1711/Synapsers.Oauth.Matterport/releases) for the latest updates and versions. We hope you find this library helpful in your development journey with Matterport!