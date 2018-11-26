# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator

SLOT="0"
PV_STRING="$(get_version_component_range 4-6)"
MY_PV="$(get_version_component_range 1-2)"
MY_PN="PhpStorm"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(get_version_component_range 7)x" = "prex" ]]
then
	# upstream EAP
	KEYWORDS=""
	SRC_URI="https://download.jetbrains.com/webide/${MY_PN}-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://download.jetbrains.com/webide/${MY_PN}-${MY_PV}.tar.gz"
fi

DESCRIPTION="The Lightning-Smart PHP IDE"
HOMEPAGE="https://www.jetbrains.com/phpstorm"

LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
IUSE="-custom-jdk"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*"
if [[ "${PV_STRING}x" = "x" ]]
then
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
else
	S="${WORKDIR}/${MY_PN}-${PV_STRING}"
fi

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

src_prepare() {
	if ! use custom-jdk; then
		if [[ -d jre64 ]]; then
			rm -r jre64 || die
		fi
	fi
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,fsnotifier{,64},inspect.sh,phpstorm.sh,printenv.py,restart.py}
	if use custom-jdk; then
		if [[ -d jre64 ]]; then
			fperms -R 755 "${dir}"/jre64/bin
		fi
	fi

	dosym ${dir}/bin/phpstorm.sh /usr/bin/${PN}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "${MY_PN} ${MY_PV}" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

