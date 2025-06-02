namespace TestApp.Data
{
    public class MatterportAppOptions
    {
        public string ClientId { get; set; } = "";
        public string ClientSecret { get; set; } = "";
        public string[] Scope { get; set; } = Array.Empty<string>();
    }
}
