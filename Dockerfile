###########################################################
# Dockerfile that builds a Palworld Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="saitcho@outlook.com"

ENV USER steam
ENV STEAMAPPID 2667530
ENV STEAMAPP sunkenland
ENV STEAMAPPDIR "/data/sunkenland"
ENV DLURL https://raw.githubusercontent.com/dkirby-ms/sunkenland

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.21-1+deb11u1 \
		ca-certificates=20210119 \
		iputils-ping=3:20210202-1 \
	# Add entry script
	&& mkdir -p "${STEAMAPPDIR}" \
	&& wget --max-redirect=30 "${DLURL}/master/scripts/entry.sh" -O "/home/${USER}/entry.sh" \
	&& chmod +x "/home/${USER}/entry.sh" \
	&& chown -R "${USER}:${USER}" "/home/${USER}/entry.sh" "${STEAMAPPDIR}" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/*

ENV STEAMCMD_UPDATE_ARGS="" \
	ADDITIONAL_ARGS=""

# Switch to user
USER ${USER}

WORKDIR "/home/${USER}"

CMD ["bash", "entry.sh"] 

# Expose ports
EXPOSE 8211/tcp \
	8211/udp