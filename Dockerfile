# r-s2i
FROM r-base:latest

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Changduk Kim <rlackdejr89@gmail.com>"
# Set labels, used by OpenShift, to identify and describe the builder image
LABEL io.k8s.description="r s2i builder example" \
      io.k8s.display-name="r training s2i builder example" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.tags="r-builder"
COPY ./s2i/bin/ /usr/libexec/s2i
RUN mkdir /app
RUN chown -R 1001:1001 /app
RUN chown -R 1001:1001 /usr/local
USER 1001
WORKDIR /app
