Errors I've had:

Knowing that you need to focus on flakes related setup (without diamond brackets)
Here is a bunch of errors and fixed that you may be looking for:

> hey im really struggling with home-manager initial setup:
>
>    If you do not plan on having Home Manager manage your shell configuration then you must source the
>
>    $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
>
>   file in your shell configuration. Alternatively source
>
>   /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh

```sh
[user@hostname:~/.nix-profile]$ ls -a
.  ..  manifest.json

[user@hostname:/etc]$ cd profiles
bash: cd: profiles: No such file or directory
```


> Am I supposed to just make those dirs and put nothing in the hm-session-vars.sh

> I've been trying to do this with
> https://github.com/Evertras/simple-homemanager/blob/main/01-install.md
> and 
> https://nix-community.github.io/home-manager/
>
> I don't see anything that explains this
> sourcing this in ~/.bashrc makes no sense if there is nothing there
>
> Did you nixos-rebuild switch after adding HM for your user? @Nobbz

> yes
> it didnt fail (it might be confusing my user is literally "user" and my hostname is literally "hostname" 
```sh
[user@hostname:/etc/nixos]$ sudo nixos-rebuild switch
building the system configuration...
activating the configuration...
setting up /etc...
reloading user units for user...
restarting sysinit-reactivation.target
```
> Anything in the logs of your user activation service? @Nobbz

```sh
journalctl -xeu home-manager-$USER.service
```

```sh
Jul 18 14:51:43 hostname hm-activate-user[2691]: Starting Home Manager activation
Jul 18 14:51:43 hostname hm-activate-user[2691]: Activating checkFilesChanged
Jul 18 14:51:43 hostname hm-activate-user[2691]: Activating checkLinkTargets
Jul 18 14:51:43 hostname hm-activate-user[2938]: Existing file '/home/user/.bashrc' is in the way of '/nix/store/ax6202zpsiwwfdl9x11s0faikcysdxwp-home-manager-files/.bashrc'
Jul 18 14:51:43 hostname hm-activate-user[2938]: Please do one of the following:
Jul 18 14:51:43 hostname hm-activate-user[2938]: - Move or remove the above files and try again.
Jul 18 14:51:43 hostname hm-activate-user[2938]: - In standalone mode, use 'home-manager switch -b backup' to back up
Jul 18 14:51:43 hostname hm-activate-user[2938]:   files automatically.
Jul 18 14:51:43 hostname hm-activate-user[2938]: - When used as a NixOS or nix-darwin module, set
Jul 18 14:51:43 hostname hm-activate-user[2938]:     'home-manager.backupFileExtension'
Jul 18 14:51:43 hostname hm-activate-user[2938]:   to, for example, 'backup' and rebuild.
Jul 18 14:51:41 hostname systemd[1]: Starting Home Manager environment for user...
░░ Subject: A start job for unit home-manager-user.service has begun execution
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ A start job for unit home-manager-user.service has begun execution.
░░ 
░░ The job identifier is 102.
Jul 18 14:51:42 hostname systemd[1]: home-manager-user.service: Main process exited, code=exited, status=1/FAILURE
░░ Subject: Unit process exited
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ An ExecStart= process belonging to unit home-manager-user.service has exited.
░░ 
░░ The process' exit code is 'exited' and its exit status is 1.
Jul 18 14:51:42 hostname systemd[1]: home-manager-user.service: Failed with result 'exit-code'.
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ The unit home-manager-user.service has entered the 'failed' state with result 'exit-code'.
Jul 18 14:51:42 hostname systemd[1]: Failed to start Home Manager environment for user.
░░ Subject: A start job for unit home-manager-user.service has failed
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ A start job for unit home-manager-user.service has finished with a failure.
░░ 
░░ The job identifier is 102 and the job result is failed.
```


```sh
[user@hostname:/etc/nixos]$ home-manager switch
Starting Home Manager activation
Activating checkFilesChanged
Activating checkLinkTargets
Activating writeBoundary
Activating installPackages
nix profile remove /nix/store/icqdaf93amhwgr6jpiyh338pindqscsk-home-manager-path
removing 'home-manager-path'
Activating linkGeneration
Cleaning up orphan links from /home/user
No change so reusing latest profile generation 1
Creating home file links in /home/user
Activating onFilesChange
Activating reloadSystemd
The user systemd session is degraded:
  UNIT           LOAD      ACTIVE SUB    DESCRIPTION   
● waybar.service not-found failed failed waybar.service

Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.

1 loaded units listed.
Attempting to reload services anyway...

There are 162 unread and relevant news items.
Read them by running the command "home-manager news".
```

> Do not run home-manager init if you want to use HM as a system module. @Nobbz

> You now have to make a decission, do you want to use HM standalone or as a system module? @Nobbz

> system module i assume you mean NixOS related?

> ofc that

> undo everything done by home-manager init @Nobbz

> And don't touch the home-manager CLI again. Best is to not install it. @Nobbz

> but it created the *vars.sh correctly do i delete that as well?

> You have to remove whatever caused adding it, yes. @Nobbz

> Because that file will be regenerated by the system module eventually @Nobbz

> i removed .config/home-manager
> also home-manager uninstall 
> it led to `*vars.sh` deletion

```sh
cd /etc/profiles
bash: cd: /etc/profiles: No such file or directory



[user@hostname:~/.nix-profile]$ ls -a
.  ..  manifest.json
```
> Okay, so now again do a nixos-rebuild switch and check the already mentioned service. Then read any logs of it carefully, and act accordingly. @Nobbz

```sh
[user@hostname:~/.nix-profile]$ sudo nixos-rebuild switch --show-trace --verbose
$ sudo cat /proc/sys/kernel/hostname
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.OCykw3/nixos-rebuild /etc/nixos#nixosConfigurations."hostname".config.system.build.nixos-rebuild --show-trace --verbose
$ exec /nix/store/6nmjydhl3f1aanz6z18k7bl21r5k8ny4-nixos-rebuild/bin/nixos-rebuild switch --show-trace --verbose
$ sudo cat /proc/sys/kernel/hostname
building the system configuration...
Building in flake mode.
$ nix --extra-experimental-features nix-command flakes build /etc/nixos#nixosConfigurations."hostname".config.system.build.toplevel --show-trace --verbose --out-link /tmp/nixos-rebuild.3TXr2g/result
$ sudo nix-env -p /nix/var/nix/profiles/system --set /nix/store/iaqgd5xgiz1iwijjrw034zwd5331iwhs-nixos-system-hostname-24.05.20240717.c716603
$ sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --same-dir --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait true
Using systemd-run to switch configuration.
$ sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --same-dir --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait /nix/store/iaqgd5xgiz1iwijjrw034zwd5331iwhs-nixos-system-hostname-24.05.20240717.c716603/bin/switch-to-configuration switch
activating the configuration...
setting up /etc...
reloading user units for user...
restarting sysinit-reactivation.target

[user@hostname:~/.nix-profile]$ journalctl -xeu home-manager-$USER.service
(lots of ~)
-- No entries --
```

really nothing wrong with the nixos-rebuild switch:
```sh
[user@hostname:~/.nix-profile]$ sudo nixos-rebuild switch
building the system configuration...
activating the configuration...
setting up /etc...
reloading user units for user...
restarting sysinit-reactivation.target
```

> Did you remove the HM stuff from it? @Nobbz

> i only have home-manager in 
```nix
# /etc/nixos/configuration.nix
...
environment.systemPackages = with pkgs; [
...
home-manager
];```

> remove that! @Nobbz
> As said, its best to get rid of the HM CLI if you do not want to use it standalone @Nobbz

> so now there would be no mention of home-manager in configuration.nix
> is this what we want?

> home-manager.* option hirarchy @Nobbz

> dont have that

Then add that. If you never had that, then I am wondering where the HM activation service comes from @Nobbz

For example, a NixOS configuration may include the lines
(Manual) and changed a things
https://nix-community.github.io/home-manager/index.xhtml#ch-installation
```nix

# users.users.eve.isNormalUser = true;
# change user to your username here
home-manager.users.user = { pkgs, ... }: {
  home.packages = [ pkgs.atool pkgs.httpie ];
  programs.bash.enable = true;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
};
```

> i had a lot of stuff that didnt work 🤷‍♂️


```sh
[user@hostname:~/.nix-profile]$ sudo nixos-rebuild switch
error:
       … while calling the 'seq' builtin

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:322:18:

          321|         options = checked options;
          322|         config = checked (removeAttrs config [ "_module" ]);
             |                  ^
          323|         _module = checked (config._module);

       … while calling the 'throw' builtin

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:298:18:

          297|                     ''
          298|             else throw baseMsg
             |                  ^
          299|         else null;

       error: The option `home-manager' does not exist. Definition values:
       - In `/nix/store/0yq0cdar3hhak1j8qidx8wxj60n25f1p-source/configuration.nix':
           {
             users = {
               user = <function, args: {pkgs}>;
             };
           }
```
> what is that? i saw this so many times
> You haven't imported the HM NixOS module @Nobbz
>
> ... <home-manager/nixos>, if you use a nix path based set up and the HM is under home-manager in the nix path @Nobbz
>
> ok so:

```sh
sudo nixos-rebuild switch 
error: cached failure of attribute 'nixosConfigurations.hostname.config'
```

```sh
[user@hostname:~]$ sudo nvim /etc/nixos/configuration.nix 
[sudo] password for user: 

[user@hostname:~]$ sudo nixos-rebuild switch
error:
       … while calling the 'seq' builtin

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:322:18:

          321|         options = checked options;
          322|         config = checked (removeAttrs config [ "_module" ]);
             |                  ^
          323|         _module = checked (config._module);

       … while evaluating a branch condition

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:261:9:

          260|       checkUnmatched =
          261|         if config._module.check && config._module.freeformType == null && merged.unmatchedDefns != [] then
             |         ^
          262|           let

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: cannot look up '<home-manager/nixos>' in pure evaluation mode (use '--impure' to override)

       at «none»:0: (source not available)

[user@hostname:~]$ sudo nixos-rebuild switch --show-trace
error: cached failure of attribute 'nixosConfigurations.hostname.config'

[user@hostname:~]$ sudo nixos-rebuild switch --show-trace --verbose
$ sudo cat /proc/sys/kernel/hostname
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.WGWczI/nixos-rebuild /etc/nixos#nixosConfigurations."hostname".config.system.build.nixos-rebuild --show-trace --verbose
error: cached failure of attribute 'nixosConfigurations.hostname.config'

[user@hostname:~]$ nix flake update
error (ignored): error: reached end of FramedSource
error:
       … while fetching the input 'path:/home/user'

       error: file '/home/user/.config/qBittorrent/ipc-socket' has an unsupported type

[user@hostname:~]$ sudo nixos-rebuild switch --flake .#
error:
       … while fetching the input 'path:/home/user'

       error: file '/home/user/.config/qBittorrent/ipc-socket' has an unsupported type

[user@hostname:~]$ sudo nvim /etc/nixos/configuration.nix 

[user@hostname:~]$ sudo nixos-rebuild switch --flake .#
error:
       … while fetching the input 'path:/home/user'

       error: file '/home/user/.config/qBittorrent/ipc-socket' has an unsupported type

[user@hostname:~]$ sudo nixos-rebuild switch --show-trace --verbose
$ sudo cat /proc/sys/kernel/hostname
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.dyphAM/nixos-rebuild /etc/nixos#nixosConfigurations."hostname".config.system.build.nixos-rebuild --show-trace --verbose
error:
       … while calling the 'seq' builtin

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:322:18:

          321|         options = checked options;
          322|         config = checked (removeAttrs config [ "_module" ]);
             |                  ^
          323|         _module = checked (config._module);

       … while evaluating a branch condition

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:261:9:

          260|       checkUnmatched =
          261|         if config._module.check && config._module.freeformType == null && merged.unmatchedDefns != [] then
             |         ^
          262|           let

       … in the left operand of the AND (&&) operator

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:261:72:

          260|       checkUnmatched =
          261|         if config._module.check && config._module.freeformType == null && merged.unmatchedDefns != [] then
             |                                                                        ^
          262|           let

       … in the left operand of the AND (&&) operator

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:261:33:

          260|       checkUnmatched =
          261|         if config._module.check && config._module.freeformType == null && merged.unmatchedDefns != [] then
             |                                 ^
          262|           let

       … while evaluating a branch condition

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:254:12:

          253|
          254|         in if declaredConfig._module.freeformType == null then declaredConfig
             |            ^
          255|           # Because all definitions that had an associated option ended in

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:242:28:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                            ^
          243|

       … while calling 'mapAttrsRecursiveCond'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1201:5:

         1200|     f:
         1201|     set:
             |     ^
         1202|     let

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:234:33:

          233|           ({ inherit lib options config specialArgs; } // specialArgs);
          234|         in mergeModules prefix (reverseList collected);
             |                                 ^
          235|

       … while calling 'reverseList'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/lists.nix:1116:17:

         1115|   */
         1116|   reverseList = xs:
             |                 ^
         1117|     let l = length xs; in genList (n: elemAt xs (l - n - 1)) l;

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:229:25:

          228|       merged =
          229|         let collected = collectModules
             |                         ^
          230|           class

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:445:37:

          444|
          445|     in modulesPath: initialModules: args:
             |                                     ^
          446|       filterModules modulesPath (collectStructuredModules unknownModule "" initialModules args);

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:446:7:

          445|     in modulesPath: initialModules: args:
          446|       filterModules modulesPath (collectStructuredModules unknownModule "" initialModules args);
             |       ^
          447|

       … while calling 'filterModules'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:413:36:

          412|       # modules recursively. It returns the final list of unique-by-key modules
          413|       filterModules = modulesPath: { disabled, modules }:
             |                                    ^
          414|         let

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:439:31:

          438|           disabledKeys = concatMap ({ file, disabled }: map (moduleKey file) disabled) disabled;
          439|           keyFilter = filter (attrs: ! elem attrs.key disabledKeys);
             |                               ^
          440|         in map (attrs: attrs.module) (builtins.genericClosure {

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:400:22:

          399|           let
          400|             module = checkModule (loadModule args parentFile "${parentKey}:anon-${toString n}" x);
             |                      ^
          401|             collectedImports = collectStructuredModules module._file module.key module.imports args;

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:359:11:

          358|         then
          359|           m:
             |           ^
          360|             if m._class != null -> m._class == class

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:400:35:

          399|           let
          400|             module = checkModule (loadModule args parentFile "${parentKey}:anon-${toString n}" x);
             |                                   ^
          401|             collectedImports = collectStructuredModules module._file module.key module.imports args;

       … while calling 'loadModule'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:336:53:

          335|       # Like unifyModuleSyntax, but also imports paths and calls functions if necessary
          336|       loadModule = args: fallbackFile: fallbackKey: m:
             |                                                     ^
          337|         if isFunction m then

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:337:12:

          336|       loadModule = args: fallbackFile: fallbackKey: m:
          337|         if isFunction m then
             |            ^
          338|           unifyModuleSyntax fallbackFile fallbackKey (applyModuleArgs fallbackKey m args)

       … while calling 'isFunction'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/trivial.nix:929:16:

          928|   */
          929|   isFunction = f: builtins.isFunction f ||
             |                ^
          930|     (f ? __functor && isFunction (f.__functor f));

       error: cannot look up '<home-manager/nixos>' in pure evaluation mode (use '--impure' to override)

       at «none»:0: (source not available)

[user@hostname:~]$ sudo nixos-rebuild switch --show-trace --verbose --impure
$ sudo cat /proc/sys/kernel/hostname
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.g1ZYsk/nixos-rebuild /etc/nixos#nixosConfigurations."hostname".config.system.build.nixos-rebuild --show-trace --verbose --impure
$ exec /nix/store/6nmjydhl3f1aanz6z18k7bl21r5k8ny4-nixos-rebuild/bin/nixos-rebuild switch --show-trace --verbose --impure
$ sudo cat /proc/sys/kernel/hostname
building the system configuration...
Building in flake mode.
$ nix --extra-experimental-features nix-command flakes build /etc/nixos#nixosConfigurations."hostname".config.system.build.toplevel --show-trace --verbose --impure --out-link /tmp/nixos-rebuild.gVWMtM/result
these 18 derivations will be built:
  /nix/store/7kp698q45gyyx7ppsi08p6xcs3d1qy6a-activation-script.drv
  /nix/store/18vqfg74l7m6d2qdwyw7vv3v7nnvclds-home-manager-generation.drv
  /nix/store/2znaj5w4q2rf23snyf0sl16k1ghrc74s-unit-home-manager-user.service.drv
  /nix/store/ww0z34m6l0d7n75jchxh2nz1hv6f1as4-system-path.drv
  /nix/store/3fnyifgwl34imkaa10mcs9gfbd39n51g-dbus-1.drv
  /nix/store/s0wn4zvhm8xasg5ad7n02bb4sfsk9cx8-X-Restart-Triggers-dbus.drv
  /nix/store/4x5dfx8q0p4iggiimmr7rmpv81lnv1w2-unit-dbus.service.drv
  /nix/store/9bcyfl598pajj9s94iqsr0ry5yvalnyk-etc-pam-environment.drv
  /nix/store/h5h1skxcxr2ykzfzl2qdjmpmfx9jdrzx-X-Restart-Triggers-polkit.drv
  /nix/store/ahg7fcbjr4309nm0wsrfy0sqqw6xri0i-unit-polkit.service.drv
  /nix/store/yai3z2r4bzpjb1fb2hzmmpgmn5a5h1ih-unit-accounts-daemon.service.drv
  /nix/store/cb861znyr9gksys49l6b58j1lv66dngv-system-units.drv
  /nix/store/pdz5lacgfv4bzx2f4m5apxdhgx8dwmf1-unit-dbus.service.drv
  /nix/store/izdpvka08i00yf3zxb3psvmqpsjk7nhf-user-units.drv
  /nix/store/qzf3br5ciyq733b7wzz0qm4p62wq9m4q-set-environment.drv
  /nix/store/m3mri3mjflg67z1l97jnpis603wykn5a-etc-profile.drv
  /nix/store/x9i724ysydawma9agmbb39420qinyakq-etc.drv
  /nix/store/xas6w7k8qlfim05ngp13hy175n8364ym-nixos-system-hostname-24.05.20240717.c716603.drv
building '/nix/store/ww0z34m6l0d7n75jchxh2nz1hv6f1as4-system-path.drv'...
building '/nix/store/7kp698q45gyyx7ppsi08p6xcs3d1qy6a-activation-script.drv'...
building '/nix/store/18vqfg74l7m6d2qdwyw7vv3v7nnvclds-home-manager-generation.drv'...
building '/nix/store/2znaj5w4q2rf23snyf0sl16k1ghrc74s-unit-home-manager-user.service.drv'...
building '/nix/store/h5h1skxcxr2ykzfzl2qdjmpmfx9jdrzx-X-Restart-Triggers-polkit.drv'...
building '/nix/store/3fnyifgwl34imkaa10mcs9gfbd39n51g-dbus-1.drv'...
building '/nix/store/9bcyfl598pajj9s94iqsr0ry5yvalnyk-etc-pam-environment.drv'...
building '/nix/store/qzf3br5ciyq733b7wzz0qm4p62wq9m4q-set-environment.drv'...
building '/nix/store/yai3z2r4bzpjb1fb2hzmmpgmn5a5h1ih-unit-accounts-daemon.service.drv'...
building '/nix/store/s0wn4zvhm8xasg5ad7n02bb4sfsk9cx8-X-Restart-Triggers-dbus.drv'...
building '/nix/store/m3mri3mjflg67z1l97jnpis603wykn5a-etc-profile.drv'...
building '/nix/store/ahg7fcbjr4309nm0wsrfy0sqqw6xri0i-unit-polkit.service.drv'...
building '/nix/store/4x5dfx8q0p4iggiimmr7rmpv81lnv1w2-unit-dbus.service.drv'...
building '/nix/store/pdz5lacgfv4bzx2f4m5apxdhgx8dwmf1-unit-dbus.service.drv'...
building '/nix/store/cb861znyr9gksys49l6b58j1lv66dngv-system-units.drv'...
building '/nix/store/izdpvka08i00yf3zxb3psvmqpsjk7nhf-user-units.drv'...
building '/nix/store/x9i724ysydawma9agmbb39420qinyakq-etc.drv'...
building '/nix/store/xas6w7k8qlfim05ngp13hy175n8364ym-nixos-system-hostname-24.05.20240717.c716603.drv'...
$ sudo nix-env -p /nix/var/nix/profiles/system --set /nix/store/gykqhshvqz6lvj9fpfjwfwcyycp9z058-nixos-system-hostname-24.05.20240717.c716603
$ sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --same-dir --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait true
Using systemd-run to switch configuration.
$ sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --same-dir --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait /nix/store/gykqhshvqz6lvj9fpfjwfwcyycp9z058-nixos-system-hostname-24.05.20240717.c716603/bin/switch-to-configuration switch
stopping the following units: accounts-daemon.service
activating the configuration...
setting up /etc...
reloading user units for user...
restarting sysinit-reactivation.target
reloading the following units: dbus.service
restarting the following units: polkit.service
starting the following units: accounts-daemon.service
the following new units were started: home-manager-user.service, sysinit-reactivation.target, systemd-tmpfiles-resetup.service

[user@hostname:~]$ sudo nixos-rebuild switch 
error: cached failure of attribute 'nixosConfigurations.hostname.config'

[user@hostname:~]$ sudo nixos-rebuild switch --show-trace
error: cached failure of attribute 'nixosConfigurations.hostname.config'

[user@hostname:~]$ sudo nixos-rebuild switch --show-trace --verbose
$ sudo cat /proc/sys/kernel/hostname
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.BJGwZS/nixos-rebuild /etc/nixos#nixosConfigurations."hostname".config.system.build.nixos-rebuild --show-trace --verbose
error: cached failure of attribute 'nixosConfigurations.hostname.config'

[user@hostname:~]$ sudo nixos-rebuild switch --impure 
building the system configuration...
activating the configuration...
setting up /etc...
reloading user units for user...
restarting sysinit-reactivation.target

[user@hostname:~]$ sudo nixos-rebuild switch 
error: cached failure of attribute 'nixosConfigurations.hostname.config'
```

> You seem to be using flakes. Use the flake input instead @Nobbz
```nix
# flake.nix (broken but I don't know yet)
 cat flake.nix
{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
      ];
    };
  };
}
```

> Please check the HM manual there is a flake with an example of how to do HM as a system module with flakes. "merge" that with what you have here. @Nobbz
> Flakes don't work with the nix path, as the nix pathbis considered impure.
> So anything you'd normally use the nix path for, has to be used via inputs when using flakes

```nix
# flake.nix (still broken)

  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jdoe = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
```

> do i need unstable release to use flakes + HM?
> No @Nobbz
> i don't have the home.nix
> Create it @Nobbz
```sh
[user@hostname:/etc/nixos]$ sudo nixos-rebuild switch --flake .#
error: undefined variable 'home-manager'

       at /nix/store/h1y44cqmf7z64zswd5mw2chfjjp53xim-source/flake.nix:20:2:

           19|         ./configuration.nix
           20|     home-manager.nixosModules.home-manager
             |  ^
           21|     {
```

```diff
-     outputs = { self, nixpkgs, ... }@inputs: {
+     outputs = inputs@{ nixpkgs, home-manager, ... }: {
```
> and now it is:
```sh
[user@hostname:/etc/nixos]$ sudo nixos-rebuild switch
warning: updating lock file '/etc/nixos/flake.lock':
• Added input 'home-manager':
    'github:nix-community/home-manager/afd2021bedff2de92dfce0e257a3d03ae65c603d' (2024-07-16)
• Added input 'home-manager/nixpkgs':
    follows 'nixpkgs'
error:
       … while calling the 'seq' builtin

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:322:18:

          321|         options = checked options;
          322|         config = checked (removeAttrs config [ "_module" ]);
             |                  ^
          323|         _module = checked (config._module);

       … while evaluating a branch condition

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:261:9:

          260|       checkUnmatched =
          261|         if config._module.check && config._module.freeformType == null && merged.unmatchedDefns != [] then
             |         ^
          262|           let

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: cannot look up '<home-manager/nixos>' in pure evaluation mode (use '--impure' to override)

       at «none»:0: (source not available)


[user@hostname:/etc/nixos]$ sudo nixos-rebuild switch --flake .#
error: cached failure of attribute 'nixosConfigurations.hostname.config'
```

> is there a way to delete the cache for that?
> oh yeah so with --option eval-cache false it just prints the above longer error

```sh
[user@hostname:/etc/nixos]$ sudo nixos-rebuild switch --flake .#hostname --option eval-cache false --impure --show-trace --verbose
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.fFPs6Y/nixos-rebuild .#nixosConfigurations."hostname".config.system.build.nixos-rebuild --option eval-cache false --impure --show-trace --verbose
$ exec /nix/store/6nmjydhl3f1aanz6z18k7bl21r5k8ny4-nixos-rebuild/bin/nixos-rebuild switch --flake .#hostname --option eval-cache false --impure --show-trace --verbose
building the system configuration...
Building in flake mode.
$ nix --extra-experimental-features nix-command flakes build .#nixosConfigurations."hostname".config.system.build.toplevel --option eval-cache false --impure --show-trace --verbose --out-link /tmp/nixos-rebuild.D5r6th/result
error:
       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1571:24:

         1570|     let f = attrPath:
         1571|       zipAttrsWith (n: values:
             |                        ^
         1572|         let here = attrPath ++ [n]; in

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1205:18:

         1204|         mapAttrs
         1205|           (name: value:
             |                  ^
         1206|             if isAttrs value && cond value

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1208:18:

         1207|             then recurse (path ++ [ name ]) value
         1208|             else f (path ++ [ name ]) value);
             |                  ^
         1209|     in

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `system.build.toplevel':

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))

       … while evaluating definitions from `/nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/nixos/modules/system/activation/top-level.nix':

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))
             |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/nixos/modules/system/activation/top-level.nix:71:12:

           70|   # Replace runtime dependencies
           71|   system = foldr ({ oldDependency, newDependency }: drv:
             |            ^
           72|       pkgs.replaceDependency { inherit oldDependency newDependency drv; }

       … while calling 'foldr'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/lists.nix:121:20:

          120|   */
          121|   foldr = op: nul: list:
             |                    ^
          122|     let

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/lists.nix:128:8:

          127|         else op (elemAt list n) (fold' (n + 1));
          128|     in fold' 0;
             |        ^
          129|

       … while calling 'fold''

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/lists.nix:124:15:

          123|       len = length list;
          124|       fold' = n:
             |               ^
          125|         if n == len

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1205:18:

         1204|         mapAttrs
         1205|           (name: value:
             |                  ^
         1206|             if isAttrs value && cond value

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1208:18:

         1207|             then recurse (path ++ [ name ]) value
         1208|             else f (path ++ [ name ]) value);
             |                  ^
         1209|     in

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `assertions':

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))

       … while evaluating definitions from `/nix/var/nix/profiles/per-user/root/channels/home-manager/nixos/common.nix':

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))
             |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1205:18:

         1204|         mapAttrs
         1205|           (name: value:
             |                  ^
         1206|             if isAttrs value && cond value

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:676:37:

          675|
          676|       matchedOptions = mapAttrs (n: v: v.matchedOptions) resultsByName;
             |                                     ^
          677|

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:646:32:

          645|             in {
          646|               matchedOptions = evalOptionValue loc opt defns';
             |                                ^
          647|               unmatchedDefns = [];

       … while calling 'evalOptionValue'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:780:31:

          779|      config value. */
          780|   evalOptionValue = loc: opt: defs:
             |                               ^
          781|     let

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:805:9:

          804|       warnDeprecation =
          805|         warnIf (opt.type.deprecationMessage != null)
             |         ^
          806|           "The type `types.${opt.type.name}' of option `${showOption loc}' defined in ${showFiles opt.declarations} is deprecated. ${opt.type.deprecationMessage}";

       … while calling 'warnIf'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/trivial.nix:729:18:

          728|   */
          729|   warnIf = cond: msg: if cond then warn msg else x: x;
             |                  ^
          730|

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:644:23:

          643|           if length optionDecls == length decls then
          644|             let opt = fixupOptionType loc (mergeOptionDecls loc decls);
             |                       ^
          645|             in {

       … while calling 'fixupOptionType'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:957:26:

          956|   # TODO: Merge this into mergeOptionDecls
          957|   fixupOptionType = loc: opt:
             |                          ^
          958|     if opt.type.getSubModules or null == null

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:644:44:

          643|           if length optionDecls == length decls then
          644|             let opt = fixupOptionType loc (mergeOptionDecls loc decls);
             |                                            ^
          645|             in {

       … while calling 'mergeOptionDecls'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:741:9:

          740|   mergeOptionDecls =
          741|    loc: opts:
             |         ^
          742|     foldl' (res: opt:

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:742:18:

          741|    loc: opts:
          742|     foldl' (res: opt:
             |                  ^
          743|       let t  = res.type;

       error: The option `home-manager.users' in `/nix/store/lk3d5lnbsxyv8bkr9vyqc589ivcgnz9n-source/nixos/common.nix' is already declared in `/nix/var/nix/profiles/per-user/root/channels/home-manager/nixos/common.nix'.
```
> You have of course to remove the usage of the diamond path @Nobbz
> wdym diamond path... 
> at least the home-manager service is active 

had to delete the home-manager module from the import: https://github.com/jirafey/nixconfig/commit/aed804b637ba727477d378a102e41fa955897854

```diff
# configuration.nix

{
  imports =
    [ # Include the results of the hardware scan.
-      <home-manager/nixos>
+      # <home-manager/nixos>
      ./hardware-configuration.nix
    # <nixos-hardware/lenovo/ideapad/16ach6>
    ];
```

```sh
[user@hostname:~]$ sudo nixos-rebuild switch --flake .#hostname --option eval-cache false --impure --show-trace --verbose
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.28WfqP/nixos-rebuild .#nixosConfigurations."hostname".config.system.build.nixos-rebuild --option eval-cache false --impure --show-trace --verbose
error:
       … while updating the lock file of flake 'path:/home/user?lastModified=0&narHash=sha256-OnV/eDM1mSyrg3NwhPOANBnYuw4LoZVd4CLkRiQocNs%3D'

       … while updating the flake input 'nixpkgs'

       … while fetching the input 'github:nixos/nixos-24.05'

       error: unable to download 'https://api.github.com/repos/nixos/nixos-24.05/commits/HEAD': HTTP error 404

       response body:

       {
         "message": "Not Found",
         "documentation_url": "https://docs.github.com/rest/commits/commits#get-a-commit",
         "status": "404"
       }```

https://discourse.nixos.org/t/home-manager-still-doesnt-work-for-me/49263

```sh
[user@hostname:/etc/nixos]$ sudo nix flake update
warning: updating lock file '/etc/nixos/flake.lock':
• Updated input 'nixpkgs':
    'github:nixos/nixpkgs/2a57b049d44d14b3cba98746e8b66ac0bc4c2963' (2024-07-18)
  → 'github:nixos/nixpkgs/c716603a63aca44f39bef1986c13402167450e0a' (2024-07-17)

[user@hostname:/etc/nixos]$ sudo nixos-rebuild switch --flake .#hostname --option eval-cache false --impure --show-trace --verbose
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.wX3fYX/nixos-rebuild .#nixosConfigurations."hostname".config.system.build.nixos-rebuild --option eval-cache false --impure --show-trace --verbose
$ exec /nix/store/6nmjydhl3f1aanz6z18k7bl21r5k8ny4-nixos-rebuild/bin/nixos-rebuild switch --flake .#hostname --option eval-cache false --impure --show-trace --verbose
building the system configuration...
Building in flake mode.
$ nix --extra-experimental-features nix-command flakes build .#nixosConfigurations."hostname".config.system.build.toplevel --option eval-cache false --impure --show-trace --verbose --out-link /tmp/nixos-rebuild.yem5Zp/result
error:
       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1571:24:

         1570|     let f = attrPath:
         1571|       zipAttrsWith (n: values:
             |                        ^
         1572|         let here = attrPath ++ [n]; in

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1205:18:

         1204|         mapAttrs
         1205|           (name: value:
             |                  ^
         1206|             if isAttrs value && cond value

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1208:18:

         1207|             then recurse (path ++ [ name ]) value
         1208|             else f (path ++ [ name ]) value);
             |                  ^
         1209|     in

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `system.build.toplevel':

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))

       … while evaluating definitions from `/nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/nixos/modules/system/activation/top-level.nix':

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))
             |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/nixos/modules/system/activation/top-level.nix:71:12:

           70|   # Replace runtime dependencies
           71|   system = foldr ({ oldDependency, newDependency }: drv:
             |            ^
           72|       pkgs.replaceDependency { inherit oldDependency newDependency drv; }

       … while calling 'foldr'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/lists.nix:121:20:

          120|   */
          121|   foldr = op: nul: list:
             |                    ^
          122|     let

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/lists.nix:128:8:

          127|         else op (elemAt list n) (fold' (n + 1));
          128|     in fold' 0;
             |        ^
          129|

       … while calling 'fold''

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/lists.nix:124:15:

          123|       len = length list;
          124|       fold' = n:
             |               ^
          125|         if n == len

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1205:18:

         1204|         mapAttrs
         1205|           (name: value:
             |                  ^
         1206|             if isAttrs value && cond value

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1208:18:

         1207|             then recurse (path ++ [ name ]) value
         1208|             else f (path ++ [ name ]) value);
             |                  ^
         1209|     in

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `assertions':

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))

       … while evaluating definitions from `/nix/var/nix/profiles/per-user/root/channels/home-manager/nixos/common.nix':

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value))
             |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/attrsets.nix:1205:18:

         1204|         mapAttrs
         1205|           (name: value:
             |                  ^
         1206|             if isAttrs value && cond value

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:676:37:

          675|
          676|       matchedOptions = mapAttrs (n: v: v.matchedOptions) resultsByName;
             |                                     ^
          677|

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:646:32:

          645|             in {
          646|               matchedOptions = evalOptionValue loc opt defns';
             |                                ^
          647|               unmatchedDefns = [];

       … while calling 'evalOptionValue'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:780:31:

          779|      config value. */
          780|   evalOptionValue = loc: opt: defs:
             |                               ^
          781|     let

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:805:9:

          804|       warnDeprecation =
          805|         warnIf (opt.type.deprecationMessage != null)
             |         ^
          806|           "The type `types.${opt.type.name}' of option `${showOption loc}' defined in ${showFiles opt.declarations} is deprecated. ${opt.type.deprecationMessage}";

       … while calling 'warnIf'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/trivial.nix:729:18:

          728|   */
          729|   warnIf = cond: msg: if cond then warn msg else x: x;
             |                  ^
          730|

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:644:23:

          643|           if length optionDecls == length decls then
          644|             let opt = fixupOptionType loc (mergeOptionDecls loc decls);
             |                       ^
          645|             in {

       … while calling 'fixupOptionType'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:957:26:

          956|   # TODO: Merge this into mergeOptionDecls
          957|   fixupOptionType = loc: opt:
             |                          ^
          958|     if opt.type.getSubModules or null == null

       … from call site

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:644:44:

          643|           if length optionDecls == length decls then
          644|             let opt = fixupOptionType loc (mergeOptionDecls loc decls);
             |                                            ^
          645|             in {

       … while calling 'mergeOptionDecls'

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:741:9:

          740|   mergeOptionDecls =
          741|    loc: opts:
             |         ^
          742|     foldl' (res: opt:

       … while calling anonymous lambda

         at /nix/store/sj9yrq21wbbfr5715hys3laa2qd6x471-source/lib/modules.nix:742:18:

          741|    loc: opts:
          742|     foldl' (res: opt:
             |                  ^
          743|       let t  = res.type;

       error: The option `home-manager.users' in `/nix/store/lk3d5lnbsxyv8bkr9vyqc589ivcgnz9n-source/nixos/common.nix' is already declared in `/nix/var/nix/profiles/per-user/root/channels/home-manager/nixos/common.nix'.
```

```sh
[user@hostname:/etc/nixos]$ sudo nixos-rebuild switch --flake .#hostname --option eval-cache false --impure --show-trace --verbose
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.5BXIQ8/nixos-rebuild .#nixosConfigurations."hostname".config.system.build.nixos-rebuild --option eval-cache false --impure --show-trace --verbose
$ exec /nix/store/6nmjydhl3f1aanz6z18k7bl21r5k8ny4-nixos-rebuild/bin/nixos-rebuild switch --flake .#hostname --option eval-cache false --impure --show-trace --verbose
building the system configuration...
Building in flake mode.
$ nix --extra-experimental-features nix-command flakes build .#nixosConfigurations."hostname".config.system.build.toplevel --option eval-cache false --impure --show-trace --verbose --out-link /tmp/nixos-rebuild.WGlLnf/result
trace: warning: user profile: You are using

  Home Manager version 24.11 and
  Nixpkgs version 24.05.

Using mismatched versions is likely to cause errors and unexpected
behavior. It is therefore highly recommended to use a release of Home
Manager that corresponds with your chosen release of Nixpkgs.

If you insist then you can disable this warning by adding

  home.enableNixpkgsReleaseCheck = false;

to your configuration.

these 28 derivations will be built:
  /nix/store/70zr24b0ya3r2jb14fsak8ian3z6yc24-options.json.drv
  /nix/store/16bnr6vwr0x01p8dkadva7mwcc19aykg-home-configuration-reference-manpage.drv
  /nix/store/2mq2ds7kk0q2xbvbrgaljscb4z30aic6-dummy-fc-dir1.drv
  /nix/store/cyv09ihkgwj6gfcrr56q4yqmbnl7zy3s-system-path.drv
  /nix/store/2w451gldlwnim8i81262380gmj3v6ba2-etc-pam-environment.drv
  /nix/store/z37jkbh9z2fsfvkng2w6g5rmxxrvilq9-dbus-1.drv
  /nix/store/nwb15n2x5s0i3wdpfvqwqfivz16v00gq-X-Restart-Triggers-dbus.drv
  /nix/store/97q1f0bas6gi40q1mn87djfwqqyss27j-unit-dbus.service.drv
  /nix/store/64mrg6y475yn8x77x9lpj9yvf6hvw571-user-units.drv
  /nix/store/5q4kiskxzfsiyhjr6s3lcv7k6nvyj6y6-dummy-fc-dir2.drv
  /nix/store/dz955yvqn2k3191rrck9zmz5izci3z23-home-manager-path.drv
  /nix/store/6wm3rndilwnlkh66vyax8mz0cmcgrz42-user-environment.drv
  /nix/store/c0kxc6b4463r49d3wdmqj0dsy54k7izh-set-environment.drv
  /nix/store/ja1bx7sasxivgyx7yawfsc1spxicvwx4-etc-profile.drv
  /nix/store/7cmqg917qvkq3acglw3ixl943idpsdh5-unit-dbus.service.drv
  /nix/store/wgg6lwv53v59n3b0hqzhg1hmshm7v24f-activation-script.drv
  /nix/store/jza3j2r0l0b4dljwnhj3rch715nigfrx-hm_fontconfigconf.d52hmdefaultfonts.conf.drv
  /nix/store/mfjq2s1lsyjprh3p5zbskkm4q1chx24s-profile.drv
  /nix/store/pdwyjwyg1p1x1vj23jy20j2l0nsz3r0m-hm_fontconfigconf.d10hmfonts.conf.drv
  /nix/store/x0zlha77bjgrpqwhj0h1h3sbmmzhfsyc-home-manager-files.drv
  /nix/store/lmvhkqp1q7g7l3c9d2yd3rshbgnaxl59-home-manager-generation.drv
  /nix/store/gnbi31335fp6n11g82kx0x11ycpwclqc-unit-home-manager-user.service.drv
  /nix/store/sx4ijvsjplx511w81s573a89llgd2hj5-X-Restart-Triggers-polkit.drv
  /nix/store/kzh69gx0zappmssib5jidsn7m71fw1s0-unit-polkit.service.drv
  /nix/store/p4lkmsyw0lc52llwzyfl42ffs6f1anv7-unit-accounts-daemon.service.drv
  /nix/store/qsliri1axxp7p7lwmn8r0adrx0zfrdq2-system-units.drv
  /nix/store/g6vp3c027wkzwjknjndmk5cxzdkyv4nj-etc.drv
  /nix/store/4lwfi4rxphz3p2p45j4j9j1h5jm136zz-nixos-system-hostname-24.05.20240717.c716603.drv
building '/nix/store/cyv09ihkgwj6gfcrr56q4yqmbnl7zy3s-system-path.drv'...
building '/nix/store/2mq2ds7kk0q2xbvbrgaljscb4z30aic6-dummy-fc-dir1.drv'...
building '/nix/store/5q4kiskxzfsiyhjr6s3lcv7k6nvyj6y6-dummy-fc-dir2.drv'...
building '/nix/store/wgg6lwv53v59n3b0hqzhg1hmshm7v24f-activation-script.drv'...
building '/nix/store/jza3j2r0l0b4dljwnhj3rch715nigfrx-hm_fontconfigconf.d52hmdefaultfonts.conf.drv'...
building '/nix/store/mfjq2s1lsyjprh3p5zbskkm4q1chx24s-profile.drv'...
building '/nix/store/70zr24b0ya3r2jb14fsak8ian3z6yc24-options.json.drv'...
building '/nix/store/16bnr6vwr0x01p8dkadva7mwcc19aykg-home-configuration-reference-manpage.drv'...
building '/nix/store/dz955yvqn2k3191rrck9zmz5izci3z23-home-manager-path.drv'...
building '/nix/store/pdwyjwyg1p1x1vj23jy20j2l0nsz3r0m-hm_fontconfigconf.d10hmfonts.conf.drv'...
building '/nix/store/6wm3rndilwnlkh66vyax8mz0cmcgrz42-user-environment.drv'...
building '/nix/store/x0zlha77bjgrpqwhj0h1h3sbmmzhfsyc-home-manager-files.drv'...
building '/nix/store/sx4ijvsjplx511w81s573a89llgd2hj5-X-Restart-Triggers-polkit.drv'...
building '/nix/store/z37jkbh9z2fsfvkng2w6g5rmxxrvilq9-dbus-1.drv'...
building '/nix/store/2w451gldlwnim8i81262380gmj3v6ba2-etc-pam-environment.drv'...
building '/nix/store/c0kxc6b4463r49d3wdmqj0dsy54k7izh-set-environment.drv'...
building '/nix/store/p4lkmsyw0lc52llwzyfl42ffs6f1anv7-unit-accounts-daemon.service.drv'...
building '/nix/store/nwb15n2x5s0i3wdpfvqwqfivz16v00gq-X-Restart-Triggers-dbus.drv'...
building '/nix/store/ja1bx7sasxivgyx7yawfsc1spxicvwx4-etc-profile.drv'...
building '/nix/store/lmvhkqp1q7g7l3c9d2yd3rshbgnaxl59-home-manager-generation.drv'...
building '/nix/store/kzh69gx0zappmssib5jidsn7m71fw1s0-unit-polkit.service.drv'...
building '/nix/store/7cmqg917qvkq3acglw3ixl943idpsdh5-unit-dbus.service.drv'...
building '/nix/store/97q1f0bas6gi40q1mn87djfwqqyss27j-unit-dbus.service.drv'...
building '/nix/store/gnbi31335fp6n11g82kx0x11ycpwclqc-unit-home-manager-user.service.drv'...
building '/nix/store/64mrg6y475yn8x77x9lpj9yvf6hvw571-user-units.drv'...
building '/nix/store/qsliri1axxp7p7lwmn8r0adrx0zfrdq2-system-units.drv'...
building '/nix/store/g6vp3c027wkzwjknjndmk5cxzdkyv4nj-etc.drv'...
building '/nix/store/4lwfi4rxphz3p2p45j4j9j1h5jm136zz-nixos-system-hostname-24.05.20240717.c716603.drv'...
$ sudo nix-env -p /nix/var/nix/profiles/system --set /nix/store/5qv2w1smp24z65z9ci5y52kic9ikank6-nixos-system-hostname-24.05.20240717.c716603
$ sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --same-dir --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait true
Using systemd-run to switch configuration.
$ sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --same-dir --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait /nix/store/5qv2w1smp24z65z9ci5y52kic9ikank6-nixos-system-hostname-24.05.20240717.c716603/bin/switch-to-configuration switch
stopping the following units: accounts-daemon.service
activating the configuration...
setting up /etc...
reloading user units for user...
restarting sysinit-reactivation.target
reloading the following units: dbus.service
restarting the following units: home-manager-user.service, polkit.service
starting the following units: accounts-daemon.service```
```diff
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
-    home-manager.inputs.nixpkgs.follows = "nixpkgs";
+    home-manager.inputs.nixpkgs.follows = "github:nix-community/home-manager/release-24.05";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
```

```sh
sudo nixos-rebuild switch --flake .#hostname
building the system configuration...
activating the configuration...
setting up /etc...
reloading user units for user...
restarting sysinit-reactivation.target
```

> is this the finish line?
> i matched them

> That means that at least the system activated successfully on first glance. Please verify also the home-manager user activation @Nobbz

```sh
[user@hostname:/etc/nixos]$ systemctl status home-manager-$USER.service
● home-manager-user.service - Home Manager environment for user
     Loaded: loaded (/etc/systemd/system/home-manager-user.service; enabled; preset: enabled)
     Active: active (exited) since Thu 2024-07-18 20:04:32 CEST; 11min ago
   Main PID: 20520 (code=exited, status=0/SUCCESS)
        CPU: 245ms

Jul 18 20:04:32 hostname hm-activate-user[20520]: Activating checkLinkTargets
Jul 18 20:04:32 hostname hm-activate-user[20520]: Activating writeBoundary
Jul 18 20:04:32 hostname hm-activate-user[20520]: Activating installPackages
Jul 18 20:04:32 hostname hm-activate-user[20520]: Activating linkGeneration
Jul 18 20:04:32 hostname hm-activate-user[20520]: Cleaning up orphan links from /home/user
Jul 18 20:04:32 hostname hm-activate-user[20520]: Creating profile generation 3
Jul 18 20:04:32 hostname hm-activate-user[20520]: Creating home file links in /home/user
Jul 18 20:04:32 hostname hm-activate-user[20520]: Activating onFilesChange
Jul 18 20:04:32 hostname hm-activate-user[20520]: Activating reloadSystemd
Jul 18 20:04:32 hostname systemd[1]: Finished Home Manager environment for user.
```

> Yes, so now HM should be there and everything you configured through it should be that way you specified @Nobbz
