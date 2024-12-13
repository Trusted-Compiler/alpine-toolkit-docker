FROM ubuntu

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install bubblewrap
RUN chmod u+s /usr/bin/bwrap

RUN mkdir /trusted-root


COPY ./seed/stage0-posix/x86/ /trusted-root/x86/
COPY ./seed/stage0-posix/M2-Mesoplanet/ /trusted-root/M2-Mesoplanet/
COPY ./seed/stage0-posix/M2-Planet/ /trusted-root/M2-Planet/
COPY ./seed/stage0-posix/M2libc/ /trusted-root/M2libc/
COPY ./seed/stage0-posix/bootstrap-seeds/ /trusted-root/bootstrap-seeds/
COPY ./seed/stage0-posix/mescc-tools/ /trusted-root/mescc-tools/
COPY ./seed/stage0-posix/mescc-tools-extra/ /trusted-root/mescc-tools-extra/
COPY ./seed/stage0-posix/kaem.x86 /trusted-root/kaem.x86
COPY ./seed/stage0-posix/x86.answers /trusted-root/x86.answers

COPY ./seed/configurator.c /trusted-root/configurator.c
COPY ./seed/configurator.x86.checksums /trusted-root/configurator.x86.checksums
COPY ./seed/preseeded.kaem /trusted-root/preseeded.kaem
COPY ./seed/script-generator.c /trusted-root/script-generator.c
COPY ./seed/script-generator.x86.checksums /trusted-root/script-generator.x86.checksums
COPY ./seed/seed.kaem /trusted-root/seed.kaem

COPY ./steps/ /trusted-root/steps/

RUN mkdir /trusted-root/external
COPY ./distfiles/ /trusted-root/external/distfiles/

COPY ./seed/stage0-posix/bootstrap-seeds/POSIX/x86/hex0-seed /trusted-root/init

RUN ["bwrap",\
      "--unshare-user",\
      "--uid", "0",\
      "--gid", "0",\
      "--setenv", "PATH", "/usr/bin",\
      "--bind", "/trusted-root", "/",\
      "--dir", "/dev",\
      "--dev-bind", "/dev/null", "/dev/null",\
      "--dev-bind", "/dev/zero", "/dev/zero",\
      "--dev-bind", "/dev/random", "/dev/random",\
      "--dev-bind", "/dev/urandom", "/dev/urandom",\
      "--dev-bind", "/dev/ptmx", "/dev/ptmx",\
      "--dev-bind", "/dev/tty", "/dev/tty",\
      "--tmpfs", "/dev/shm",\
      "--proc", "/proc",\
      "--bind", "/sys", "/sys",\
      "--tmpfs", "/tmp",\
      "/init"]

