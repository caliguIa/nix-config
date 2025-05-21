{
    services.cloudflared = {
        enable = true;
        certificateFile = "/home/caligula/.cloudflared/cert.pem";
        tunnels = {
            "93cd8f38-e60c-4b91-8e46-c7d8c5273350" = {
                credentialsFile = "/var/lib/cloudflared/93cd8f38-e60c-4b91-8e46-c7d8c5273350.json";
                default = "http_status:404";
            };
            "4ea6e900-1983-443e-82bc-a7607fecd5e4" = {
                credentialsFile = "/home/caligula/.cloudflared/4ea6e900-1983-443e-82bc-a7607fecd5e4.json";
                default = "http_status:404";
                ingress = {
                    "audiobooks.calrichards.io" = {
                        service = "http://localhost:8113";
                    };
                };
            };
        };
    };
}
