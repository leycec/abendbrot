# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="libretro implementation of Mednafen PCE Fast. (PC Engine/TurboGrafx-16)"
HOMEPAGE="https://github.com/libretro/beetle-pce-fast-libretro"
SRC_URI=""

EGIT_REPO_URI="https://github.com/libretro/beetle-pce-fast-libretro.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	git-r3_fetch https://github.com/libretro/libretro-super.git HEAD
	git-r3_checkout https://github.com/libretro/libretro-super.git \
		"${WORKDIR}"/infos
	git-r3_fetch
	git-r3_checkout
}

src_compile() {
	emake core=pce-fast || die "emake failed"
}

src_install() {
	insinto /usr/$(get_libdir)/libretro
	doins "${S}"/mednafen_pce_fast_libretro.so
	insinto /usr/share/libretro/info/
	doins "${WORKDIR}"/infos/dist/info/mednafen_pce_fast_libretro.info
}

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${P}"; then
		first_install="1"
	fi
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "You need to have the following files in your 'system_directory' folder:"
		ewarn "syscard3.pce (PCE-CD BIOS)"
		ewarn ""
		ewarn "This message will only be displayed once!"
		ewarn ""
	fi
}
