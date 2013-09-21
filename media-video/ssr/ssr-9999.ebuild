# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools multilib-minimal

if [[ ${PV} = 9999 ]]; then
	inherit git-2
fi

DESCRIPTION="A Simple Screen Recorder"
HOMEPAGE="http://www.maartenbaert.be/simplescreenrecorder"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/MaartenBaert/${PN}.git
		https://github.com/MaartenBaert/${PN}.git"
	EGIT_BOOTSTRAP="eautoreconf"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/MaartenBaert/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="x264 vpx theora mp3 vorbis"

RDEPEND=">=dev-qt/qtgui-4.8.4-r1
	|| ( media-video/ffmpeg media-video/libav )
	x264? ( || ( media-video/ffmpeg media-video/libav ) )
	theora? ( || ( media-video/ffmpeg media-video/libav ) )
	vpx? ( || ( media-video/ffmpeg media-video/libav ) )
	mp3? ( || ( media-video/ffmpeg media-video/libav ) )
	vorbis? ( || ( media-video/ffmpeg media-video/libav ) )"
DEPEND="${RDEPEND}"

pkg_setup() {
	if [[ ${PV} == "9999" ]]; then
		elog
		elog "This ebuild merges the latest revision available from upstream's"
		elog "git repository, and might fail to compile or work properly once"
		elog "merged."
		elog
	fi

	if [[ ${ABI} == amd64 ]]; then
		elog "You may want to add abi_x86_32 to your use flags if you're using a"
		elog "64bit system. This is neccessary if you want to record 32bit"
		elog "applications using opengl injection"
		elog "To build these add 'media-video/ssr abi_x86' to package.use"
		elog
	fi
}

multilib_src_configure() {
	ECONF_SOURCE=${S} 
	if $(is_final_abi ${abi}); then
		econf \
			--enable-dependency-tracking
	else
		econf \
			--enable-dependency-tracking \
			--disable-ssrprogram
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
