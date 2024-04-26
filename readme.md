# Proxycannon Redux

>This project is a reintroduction of a reintroduction of the concepts created by the original proxycannon-ng. The parent fork of this project is from Black Lantern Security, who did a great job of consolidating the control and command servers into one and implementing Digital Ocean support. The original proxycannon was devised by Sprocket Security during the Wild West Hackin' Fest's hackathon.

This project was forked from the [Black Lantern Security fork](https://github.com/blacklanternsecurity/proxycannon-ng), which forked the original [proxycannon-ng](https://github.com/proxycannon/proxycannon-ng) repo.

### Why change things?

We saw the good work Black Lantern did with the original, and wanted to further build on it in the following areas:
- Control cost, making it more realistic to spin up a greater number of nodes.
- Make it easier to refresh the exit nodes. Ideally, we should be able to execute a full refresh of all the nodes and have the command node reconcile its iptables routing table with the new IPs.
- Give the user greater control over how and what resources are deployed into the environment, but define sane defaults that will work for most use-cases.

![Basic Proxycannon Network Map](https://github.com/blacklanternsecurity/proxycannon-ng/blob/master/imgs/ProxyCannon.png)

### Changelog
- TODO

### Target Changes
- TODO

### How-to
1. Add the following variables to `proxycannon.tfvars` before running
    - Private SSH Key File Location to `variable key-file`
    - Public Key Name (for VPS of Choice) to `variable sshName`
2. Run `sudo ./proxycannon.sh -p <PROVIDER ID> -c <EXIT-NODE-COUNT>`
    - Run `sudo ./proxycannon.sh -h` for a list of the provider IDs needed for `-p`
3. Run `cd connection-pack/ && sudo openvpn --config proxycannon-config.conf`
    - You may need to change directory to `.../proxycannon/tfdocs/connection-pack/` depending on where you installed proxycannon
4. Run `sudo ./proxycannon.sh -p <PROVIDER ID> -d` to delete the exit nodes and command server from your VPS
