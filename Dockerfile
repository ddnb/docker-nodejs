FROM node:10.15.3

WORKDIR /build

RUN apt-get update \
    && apt-get install -y fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb

RUN apt-get update -y

RUN apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
    libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget --fix-missing

# Init yarn dependencies
COPY package.json /build
RUN yarn install
RUN pwd;ls

# Add user admin
RUN groupadd -r admin && useradd -r -g admin -G audio,video admin \
    && mkdir -p /home/admin/Downloads \
    && mkdir -p /home/admin/code \
    && chown -R admin:admin /home/admin \
    && chown -R admin:admin /build/node_modules

# # Run everything after as non-privileged user.
USER admin

RUN cat /build/package.json

CMD ["google-chrome-unstable"]