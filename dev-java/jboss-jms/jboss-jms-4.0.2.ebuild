# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit jboss-4

DESCRIPTION="JMS module of JBoss Application Server"
GENTOO_CONF="jboss-${PVR}-gentoo.data"
SRC_URI="${BASE_URL}/${P}-gentoo.tar.bz2 ${BASE_URL}/${GENTOO_CONF} ${ECLASS_URI}"
HOMEPAGE="http://www.jboss.org"
LICENSE="LGPL-2"
IUSE="jikes"
SLOT="4"
KEYWORDS="~x86"

COMMON_DEPEND="dev-java/jgroups
	dev-java/jboss-aop
	dev-java/junit
	dev-java/concurrent-util
	=dev-java/javassist-3.1*
	=dev-java/jboss-common-${PV}*
	=dev-java/jboss-j2ee-${PV}*
	=dev-java/jboss-remoting-${PV}*
	=dev-java/jboss-jmx-${PV}*
	=dev-java/jboss-system-${PV}*"
DEPEND=">=virtual/jdk-1.3 ${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.3 ${COMMON_DEPEND}"
