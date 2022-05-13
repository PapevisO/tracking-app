FROM ruby:2.6.6-buster

# By default image is built using RAILS_ENV=development.
# You may want to customize it:
#
#   --build-arg RAILS_ENV=development
#
# See https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
#
ARG RAILS_ENV=development
ARG UID=1000
ARG GID=1000

ARG MAXMINDDB_LINK
# Open Source license key provided by Openware has some download rate and amount limits
# We strongly suggest you to create your oun key and pass via --build-arg MAXMINDDB_LICENSE_KEY
# All the guidance on how to create license key you can find here - https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/
ARG MAXMINDDB_LICENSE_KEY=T6ElPBlyOOuCyjzw
ENV MAXMINDDB_LINK=${MAXMINDDB_LINK:-https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&suffix=tar.gz&license_key=${MAXMINDDB_LICENSE_KEY}}

ARG NODE_VERSION=12.20.2
ENV NODE_VERSION=${NODE_VERSION}

ENV RAILS_ENV=${RAILS_ENV} \
    APP_HOME=/home/app

ENV TZ=UTC

# Create group "app" and user "app".
RUN groupadd -r --gid ${GID} app \
    && useradd --system --create-home --home ${APP_HOME} --shell /sbin/nologin --no-log-init \
    --gid ${GID} --uid ${UID} app

WORKDIR $APP_HOME

# Install dependencies defined in Gemfile.
RUN mkdir -p /opt/vendor/bundle \
  && gem install bundler:2.0.1 \
  && chown -R app:app /opt/vendor $APP_HOME
  
RUN chown app:app -R /usr/local/bundle

USER app

COPY --chown=app:app Gemfile-snapshot-d05fad6.tar $APP_HOME/
RUN tar -xvf Gemfile-snapshot-d05fad6.tar

RUN bundle install --jobs=$(nproc)

COPY --chown=app:app Gemfile Gemfile.lock $APP_HOME/

RUN bundle install --jobs=$(nproc)

# Download MaxMind Country DB
RUN wget -O ${APP_HOME}/geolite.tar.gz ${MAXMINDDB_LINK} \
    && mkdir -p ${APP_HOME}/geolite \
    && tar xzf ${APP_HOME}/geolite.tar.gz -C ${APP_HOME}/geolite --strip-components 1 \
    && rm ${APP_HOME}/geolite.tar.gz
ENV APP_MAXMINDDB_PATH=${APP_HOME}/geolite/GeoLite2-Country.mmdb

COPY --from=node:12.20.2-buster --chown=${UID}:${GID} /usr/local /usr/local
COPY --from=node:12.20.2-buster --chown=${UID}:${GID} /opt /opt

COPY --chown=app:app app.env babel.config.js .browserslistrc \
    config.ru package.json postcss.config.js Rakefile \
    .ruby-version yarn.lock .yarnrc $APP_HOME/

EXPOSE 3000

CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]
