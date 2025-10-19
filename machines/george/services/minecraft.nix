{pkgs, ...}: {
    services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;
        servers = {
            cool-server = {
                enable = true;
                package = pkgs.paperServers.paper-1_21_10;
                jvmOpts = "-Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paperclip.jar nogui";
                serverProperties = {
                    difficulty = 3;
                    server-port = 25566;
                    gamemode = 0;
                    max-players = 4;
                    motd = "cal's serious server";
                    simulation-distance = 10;
                    view-distance = 10;
                    network-compression-threshold = 256;
                };
                symlinks = {
                    "world/paper-world.yml" = pkgs.writeText "paper-world.yml" ''
                        chunks:
                            delay-chunk-unloads-by: 10s
                            prevent-moving-into-unloaded-chunks: true
                        entities:
                            armor-stands:
                                do-collision-entity-lookups: false
                                tick: false
                            spawning:
                                per-player-mob-spawns: true
                                non-player-arrow-despawn-rate: 60
                                alt-item-despawn-rate:
                                    enabled: true
                                    items:
                                        cobblestone: 300
                                        netherrack: 300
                                        sand: 300
                                        red_sand: 300
                                        gravel: 300
                                        dirt: 300
                                        short_grass: 300
                                        pumpkin: 300
                                        melon_slice: 300
                                        kelp: 300
                                        bamboo: 300
                                        sugar_cane: 300
                                        twisting_vines: 300
                                        weeping_vines: 300
                                        oak_leaves: 300
                                        spruce_leaves: 300
                                        birch_leaves: 300
                                        jungle_leaves: 300
                                        acacia_leaves: 300
                                        dark_oak_leaves: 300
                                        mangrove_leaves: 300
                                        cherry_leaves: 300
                                        cactus: 300
                                        diorite: 300
                                        granite: 300
                                        andesite: 300
                                        scaffolding: 600
                                        diamond: 36000
                                        diamond_axe: 36000
                                        diamond_sword: 36000
                                        diamond_hoe: 36000
                                        diamond_pickaxe: 36000
                                        diamond_shovel: 36000
                                        diamond_boots: 36000
                                        diamond_helmet: 36000
                                        diamond_leggings: 36000
                                        diamond_chestplate: 36000
                        tick-rates:
                            mob-spawner: 2
                            grass-spread: 4
                            behavior:
                                villager:
                                    validatenearbypoi: 60
                                    acquirepoi: 120
                            sensor:
                                villager:
                                    secondarypoisensor: 80
                                    nearestbedsensor: 80
                                    villagerbabiessensor: 40
                                    playersensor: 40
                                    nearestlivingentitysensor: 40
                        collisions:
                            max-entity-collisions: 2
                        environment:
                            optimize-explosions: true
                        hopper:
                            ignore-occluding-blocks: true
                        misc:
                            redstone-implementation: ALTERNATE_CURRENT
                    '';
                };
            };
        };
    };
}
