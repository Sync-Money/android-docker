# First stage of Dockerfile
FROM alpine:latest

# ENV PS2DEV /usr/local/ps2dev
# ENV PS2SDK $PS2DEV/ps2sdk
# ENV PATH   $PATH:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin

COPY . /src

RUN apk add build-base git bash wget openjdk8-jre android-tools
RUN java --version

# Second stage of Dockerfile
FROM alpine:latest  

# ENV PS2DEV /usr/local/ps2dev
# ENV PS2SDK $PS2DEV/ps2sdk
# ENV PATH $PATH:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin

# COPY --from=0 ${PS2DEV} ${PS2DEV}