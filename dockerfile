FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common sudo sed

RUN apt-add-repository non-free \
    && dpkg --add-architecture i386

RUN sed -i -e 's/Components: main/Components: main non-free/g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    apt-get install -y steamcmd \
    && rm -rf /var/lib/apt/lists/*

COPY Palserver-Settings.ini /home/steam/.steam/steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
COPY Palserver-wrapper.sh /Palserver-wrapper.sh

RUN useradd -m steam

RUN chown -R steam:steam /home/steam
RUN chown -R steam:steam /Palserver-wrapper.sh
RUN chmod 755 /Palserver-wrapper.sh

USER steam

WORKDIR /home/steam

RUN /usr/games/steamcmd +login anonymous +app_update 2394010 validate +quit

WORKDIR /home/steam/.steam

RUN ln -s steam/steamcmd/linux32 sdk32 && ln -s steam/steamcmd/linux64 sdk64
RUN ln -s /home/steam/.local/share/Steam/steamcmd /home/steam/.steam/steam/steamcmd

RUN /Palserver-wrapper.sh

USER root

RUN chown -R steam:steam /home/steam

USER steam

ENTRYPOINT [ "/home/steam/.steam/steam/steamapps/common/PalServer/PalServer.sh" ]

EXPOSE 8211
