using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.DependencyInjection;
using System;

namespace Synapsers.Oauth.Matterport
{
    public static class MatterportAuthenticationExtensions
    {
        public static AuthenticationBuilder AddMatterport(this AuthenticationBuilder builder, Action<MatterportAuthenticationOptions> configureOptions)
        {
            return builder.AddOAuth<MatterportAuthenticationOptions, MatterportAuthenticationHandler>(
                MatterportAuthenticationDefaults.AuthenticationScheme,
                MatterportAuthenticationDefaults.DisplayName,
                configureOptions);
        }
    }
}
