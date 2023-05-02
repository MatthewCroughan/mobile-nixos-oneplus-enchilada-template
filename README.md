### Building

##### `oneplus-enchilada`

- `nix build .#packages.aarch64-linux.oneplus-enchilada-images`

##### `oneplus-fajita`

- `nix build .#packages.aarch64-linux.oneplus-fajita-images`

### On x86_64-linux, NixOS
If you're running NixOS and want to build images you can flash via `fastboot`,
you'll need to emulate an arm64 machine by adding the following to your NixOS
configuration.

```
{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
```

### On x86_64-linux any distribution

Run the Binfmt SDK from the root of this repo in order to enter a virtual machine which
is itself capable of emulating arm64. You will then be able to build any of the arm64 outputs from this flake.

`nix run .#binfmt-sdk-nixos-shell`

### What is binfmt and why is it needed?

To avoid the need to cross-compile anything, and to make use of
cache.nixos.org, building via binfmt will actually spin up QEMU and emulate an
arm64 machine for every package/derivation that needs to be compiled. Binfmt is
a kernel feature that will allows programs like QEMU to be span up whenever any
program tries to spawn a process for a foreign architecture.

