# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_PN=${PN/-bin/}

inherit eutils

DESCRIPTION="Supercharge your API workflow"
HOMEPAGE="https://www.getpostman.com/"
SRC_URI="https://dl.pstmn.io/download/version/${PV}/linux64 -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/Postman"

src_install() {
	insinto /opt/${MY_PN}
	doins -r *

	exeinto /opt/${MY_PN}/app
	doexe Postman

	dosym /opt/${MY_PN}/Postman /usr/bin/${MY_PN}

	newicon -s 128 ${S}/app/resources/app/assets/icon.png postman.png

	make_desktop_entry "postman" \
		"Postman" \
		"/usr/share/icons/hicolor/128x128/apps/postman.png" \
		"Development"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

