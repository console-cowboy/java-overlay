# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg

DESCRIPTION="The Burlap web service protocol makes web services usable without requiring a large framework, and without learning yet another alphabet soup of protocols."
HOMEPAGE="http://www.caucho.com/burlap/"
SRC_URI="http://www.caucho.com/burlap/download/burlap-2.1.12-src.jar"

LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="~x86"

# TODO: some minor patching is needed for jikes
#IUSE="doc"
IUSE="doc jikes"

DEPEND="virtual/jdk
	app-arch/unzip
	dev-java/ant"	
RDEPEND="virtual/jre
	=dev-java/servletapi-2.3*"

SERVLET="servletapi-2.3 servlet.jar"

src_unpack() {
	mkdir -p ${P}/src
	unzip -qq -d ${S}/src ${DISTDIR}/${A}

	cd ${S}
	# No ant script! Bad upstream... bad!
	cp ${FILESDIR}/build-${PVR}.xml build.xml

	# Populate classpath
	cat > build.properties <<-EOF 
		classpath=$(java-pkg_getjar ${SERVLET})
	EOF
}

src_compile() {
	local antflags="-Dproject.name=${PN} jar"
	use jikes && antflags="-Dbuild.compiler=jikes ${antflags}"
	use doc && antflags="${antflags} javadoc"

	ant ${antflags} || die "Compilation failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dohtml -r dist/doc/api
}
