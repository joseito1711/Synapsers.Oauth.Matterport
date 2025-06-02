using Microsoft.AspNetCore.Authentication.OAuth;
using System.Collections.Generic;

namespace Synapsers.Oauth
{
    public class MatterportAuthenticationOptions : OAuthOptions
    {
        public MatterportAuthenticationOptions()
        {
            CallbackPath = "/signin-matterport-handler";
            AuthorizationEndpoint = MatterportAuthenticationDefaults.AuthorizationEndpoint;
            TokenEndpoint = MatterportAuthenticationDefaults.TokenEndpoint;
            Scope.Add("ViewDetails");
            Scope.Add("ViewPublic");
        }
    }
}
