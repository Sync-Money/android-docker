FROM alpine:latest

ARG SDK_TOOLS 
ARG BUILD_TOOLS
ARG ANDROID_API

ENV ANDROID_HOME /opt/sdk
ENV PATH $PATH:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/platform-tools

# Install required dependencies
RUN apk add bash unzip wget curl openjdk8

RUN echo $SDK_TOOLS

# Download and extract Android Tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS}_latest.zip -O /tmp/tools.zip && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    unzip -qq /tmp/tools.zip -d $ANDROID_HOME/cmdline-tools && \
    rm -v /tmp/tools.zip

# Install SDK Packages
RUN mkdir -p ~/.android/ && touch ~/.android/repositories.cfg && \
    yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses

RUN [ -z "$SLIM" ] && sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "patcher;v4" "emulator" "tools" "build-tools;${BUILD_TOOLS}" "platforms;android-${ANDROID_API}"

# Install Firebase CLI
RUN curl -Lo ./firebase_bin https://firebase.tools/bin/linux/latest
RUN mv firebase_bin firebase && chmod 700 firebase


# Second stage of Dockerfile
# We CAN NOT use alpine:latest because we need an alpine version based in glibc for aapt2
FROM frolvlad/alpine-glibc

ENV ANDROID_HOME /opt/sdk
ENV PATH $PATH:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/platform-tools

# Copy Firebase
COPY --from=0 /firebase /usr/bin/firebase
# Copy Android Command Tools
COPY --from=0 ${ANDROID_HOME} ${ANDROID_HOME}