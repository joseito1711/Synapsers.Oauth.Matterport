using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.OAuth;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using System.Text.Encodings.Web;
using System.Threading.Tasks;

namespace Synapsers.Oauth.Matterport
{
    public class MatterportAuthenticationHandler : OAuthHandler<MatterportAuthenticationOptions>
    {
        public MatterportAuthenticationHandler(
            IOptionsMonitor<MatterportAuthenticationOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            ISystemClock clock)
            : base(options, logger, encoder, clock)
        {
        }

        protected override Task<AuthenticationTicket> CreateTicketAsync(
            ClaimsIdentity identity,
            AuthenticationProperties properties,
            OAuthTokenResponse tokens)
        {
            // Matterport does not provide a user info endpoint, so just create a basic ticket
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, properties, Scheme.Name);
            return Task.FromResult(ticket);
        }
    }
}
