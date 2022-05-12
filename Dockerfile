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

ENV NODE_VERSION 12.20.2

COPY --from=node:12.20.2-stretch --chown=${UID}:${GID} /usr/local /usr/local
COPY --from=node:12.20.2-stretch --chown=${UID}:${GID} /opt /opt

EXPOSE 3000

CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]
