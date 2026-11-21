FROM nginxinc/nginx-unprivileged:1.29-alpine

ARG VERSION=dev
LABEL org.opencontainers.image.source="https://github.com/barisMarathon/devops-marathon-hello" \
      org.opencontainers.image.description="Demo static site for the devops-marathon platform" \
      org.opencontainers.image.licenses="MIT"

# The base image runs as uid 101; switch to root only to write the static files
USER root
COPY site/ /usr/share/nginx/html/
# Stamp the build version into the page so a deploy is visible in the browser
RUN sed -i "s/__VERSION__/${VERSION}/" /usr/share/nginx/html/index.html
USER 101

EXPOSE 8080
