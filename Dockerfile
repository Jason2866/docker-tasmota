FROM python:latest

LABEL description="Docker Container with a complete build environment for Tasmota using PlatformIO" \
      version="12.5" \
      maintainer="blakadder_" \
      organization="https://github.com/tasmota"       

# Install platformio. 
RUN pip install -U platformio

# Init project
COPY init_pio_tasmota /init_pio_tasmota

# Install project dependencies using a init project.
RUN cd /init_pio_tasmota &&\ 
    pio run -e esp8266 -e esp32 &&\
    cd ../ &&\ 
    rm -fr init_pio_tasmota &&\ 
    cp -r /root/.platformio / &&\ 
    chmod -R 777 /.platformio &&\
    mkdir /.cache /.local &&\
    chmod -R 777 /.cache /.local


COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
