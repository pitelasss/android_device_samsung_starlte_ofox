# Crownlte (aka Note9) twrp device tree

## TWRP's Build

### Download :

Use [Limited manifest for building TWRP](https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni/tree/twrp-9.0)

Maybe revert [this patch](https://github.com/3arthur6/android_kernel_samsung_starlte/commit/980c79eb1fb30813b0e0b4e9fe4062c529f2b877) if you don't use a recent kernel crosscompiler

Clone this repo to device/samsung/starlte

### Build :

```sh
. build/envsetup.sh
lunch omni_starlte-eng
make recoveryimage
