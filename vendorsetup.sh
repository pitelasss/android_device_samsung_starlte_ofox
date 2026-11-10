#
#	OrangeFox build settings for the Exynos 9810 devices
#
case "$FOX_BUILD_DEVICE" in
	crownlte|starlte|star2lte)
		export ALLOW_MISSING_DEPENDENCIES=true
		export FOX_VANILLA_BUILD=1
		export FOX_SAMSUNG_DEVICE=1
		export FOX_DRASTIC_SIZE_REDUCTION=1
		export LC_ALL="C"
		;;
esac
