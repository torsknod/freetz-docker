FROM ubuntu:latest
ENV user=freetz
ENV user_home=/home/${user}
RUN apt-get -y -qq update && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq aptitude && DEBIAN_FRONTEND=noninteractive aptitude --with-recommends -y -q full-upgrade && DEBIAN_FRONTEND=noninteractive aptitude --with-recommends -y -q install apt-utils autoconf automake>=1.10 automake-1.8 autopoint binutils bison build-essential bzip2 ecj ecj-bootstrap fastjar flex g++ gawk gcc gcc-multilib gettext git imagemagick intltool jikes lib32ncurses5-dev lib32stdc++ libacl1-dev libc6-dev-i386 libcap-dev libglib2.0-dev libncurses5-dev libreadline-dev libstring-crc32-perl libtool libtool-bin libusb-dev make>=3.81 mktemp patch patchutils perl pkg-config python realpath ruby ruby1.8 strace subversion svn texinfo tofrodos unzip wget xz-utils zlib1g-dev && useradd -m -d ${user_home} ${user}
USER ${user}
WORKDIR ${user_home}
ARG svn_path=trunk
RUN umask 0022 && svn checkout http://svn.freetz.org/${svn_path}
WORKDIR ${user_home}/${svn_path}
# Make mirror sometimes fails due to bad links to sources, which are often seldom needed or not needed any more
RUN make tools config-clean-deps && (make -k mirror || true)
