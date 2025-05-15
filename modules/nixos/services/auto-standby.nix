{
  services.cron.systemCronJobs = [ "0 1 * * * root rtcwake -m mem --date +6h" ];
}