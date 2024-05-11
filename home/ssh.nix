_: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*.devspt.com".extraOptions = {
        StrictHostKeyChecking = "no";
        UserKnownHostsFile = "/dev/null";
        LogLevel = "ERROR";
      };
      "kafka-prd-htz-jump-host".extraOptions = {
        HostName = "mongo1-prd-hidden-ams1.devspt.com";
      };
      "kafka-prd-htz-node*.devspt.com".extraOptions = {
        ProxyJump = "kafka-prd-htz-jump-host";
      };
    };
  };
}
