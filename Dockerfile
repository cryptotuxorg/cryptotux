FROM ubuntu:focal
WORKDIR /app
COPY --chown=bobby>:bobby . . 
RUN chmod +x /app/*
RUN bash /app/install-docker.sh
USER bobby
RUN bash /app/install-server.sh
