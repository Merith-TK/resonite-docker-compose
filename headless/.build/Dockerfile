FROM public.ecr.aws/docker/library/debian:12

ENV \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" 

USER root
WORKDIR /root

RUN apt update && apt upgrade -y \
    && dpkg --add-architecture i386 \
    && apt install -y \
        apt-transport-https \
        dirmngr \
        gnupg \
        ca-certificates \
        iproute2 \
        unzip \
        sqlite3 \
        fontconfig \
        lib32gcc-s1 \
        curl \
        wget \
        screen \
        sudo \
    && export GNUPGHOME=$(mktemp -d) \
    && gpg --recv-keys --no-default-keyring --keyring /etc/apt/trusted.gpg.d/mono-keyring.gpg --keyserver keyserver.ubuntu.com 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/mono-keyring.gpg] https://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list \
    && wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && echo 'deb [signed-by=/usr/share/keyrings/algiz.gpg] https://repo.algiz.nu/crystite bookworm main' | tee /etc/apt/sources.list.d/crystite.list \
    && mkdir -p /usr/share/keyrings \
    && wget -O /usr/share/keyrings/algiz.gpg https://repo.algiz.nu/algiz.gpg \
    && apt-get update \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y crystite mono-complete

# make data directories
RUN mkdir -p /data/headless /data/steamcmd
VOLUME [ "/etc/crystite", "/data/headless", "/data/steamcmd", "/data/home" ]

COPY setup.sh /setup.sh
COPY start_script.sh /start_script.sh
COPY mods_script.sh /mods_script.sh
RUN chmod +x /setup.sh /start_script.sh /mods_script.sh
ENTRYPOINT ["/setup.sh"]

