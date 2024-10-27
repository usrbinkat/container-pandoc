###############################################################################
# Use:
# - docker build --progress plain --tag docker.io/containercraft/pandoc -f Dockerfile .
# - docker run --rm -it --name pandoc --hostname pandoc --volume .:/convert docker.io/containercraft/pandoc my_document.md

###############################################################################
FROM docker.io/library/ubuntu:24.04
LABEL tag="pandoc"
ENV DEVCONTAINER="pandoc"
SHELL ["/bin/bash", "-c", "-e"]

#################################################################################
# Environment Variables

# Set locale to en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
# Disable timezone prompts
ENV TZ=UTC
# Disable package manager prompts
ENV DEBIAN_FRONTEND=noninteractive
# Set default bin directory for new packages
ENV BIN="/usr/local/bin"
# Set default binary install command
ENV INSTALL="install -m 755 -o root -g root"

# Common Dockerfile Container Build Functions
ENV apt_update="apt-get update"
ENV apt_install="TERM=linux DEBIAN_FRONTEND=noninteractive apt-get install -q --yes --no-install-recommends"
ENV apt_clean="apt-get clean && apt-get autoremove -y && apt-get purge -y --auto-remove"
ENV curl="/usr/bin/curl --silent --show-error --tlsv1.2 --location"
ENV dir_clean="\
    rm -rf \
    /var/lib/{apt,cache,log} \
    /usr/share/{doc,man,locale} \
    /var/cache/apt \
    /root/.cache \
    /var/tmp/* \
    /tmp/* \
    "

#################################################################################
# Base package and user configuration
#################################################################################

# Apt Packages
ARG APT_PKGS="\
    locales \
    pandoc \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-xetex \
    texlive-luatex \
    texlive-science \
    fonts-lmodern \
    fonts-noto-cjk \
    fonts-noto-core \
    fonts-noto-color-emoji \
    "

# Install Base Packages and Remove Unnecessary Ones
RUN echo \
    && export TEST="pandoc --version" \
    && ${apt_update} \
    && bash -c "${apt_install} ${APT_PKGS}" \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && bash -c "${apt_clean}" \
    && ${dir_clean} \
    && ${TEST} \
    && true

#################################################################################
# Set the default command
#################################################################################
ADD ./rootfs /
WORKDIR /convert
ENTRYPOINT ["pandoc-entrypoint"]

