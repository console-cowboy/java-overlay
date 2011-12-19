# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools

VISUALVM_PKG="visualvm_harness-1.3"
VISUALVM_TARBALL="visualvm_133-src.tar.gz"
NETBEANS_PROFILER_TARBALL="netbeans-profiler-visualvm_release701.tar.gz"

DESCRIPTION="A harness to build VisualVM using Free Software build tools"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="
	http://icedtea.classpath.org/download/visualvm/${VISUALVM_PKG}.tar.gz
	http://icedtea.classpath.org/download/visualvm/${VISUALVM_TARBALL}
	http://icedtea.classpath.org/download/visualvm/${NETBEANS_PROFILER_TARBALL}"

LICENSE="GPL-2-with-linking-exception"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="
	dev-java/icedtea:${SLOT}
	dev-util/netbeans:7.0"
RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	dev-java/ant-core
	dev-java/ant-nodeps"

S="${WORKDIR}/${VISUALVM_PKG}"

src_unpack() {
	unpack ${VISUALVM_PKG}.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}"/netbeans-platform-version.patch
	eautoreconf

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	export ANT_RESPECT_JAVA_HOME=TRUE
	export ANT_TASKS=ant-nodeps
}

src_configure() {
	local vmhandle=icedtea-${SLOT}
	has_version "<=dev-java/icedtea-6.1.10.4:6" && vmhandle=icedtea6

	local vmhome
	vmhome="$(GENTOO_VM=${vmhandle} java-config -O)" || die

	econf NB_PLATFORM=platform \
		--bindir="${vmhome}"/bin \
		--libdir="${vmhome}"/lib \
		--sysconfdir="${vmhome}"/lib/visualvm/etc \
		--with-netbeans-profiler-zip="${DISTDIR}"/${NETBEANS_PROFILER_TARBALL} \
		--with-visualvm-zip="${DISTDIR}"/${VISUALVM_TARBALL} \
		--with-visualvm-version=${PV} \
		--with-netbeans-home="${EPREFIX}"/usr/share/netbeans-nb-7.0 \
		--with-jdk-home="${vmhome}"
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${ED}" install

	# Don't install .desktop, file collision.
	rm -rf "${ED}"/usr/share
}
