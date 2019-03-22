FROM zeedware/openjdk-docker:8-18.09
# FROM openjdk:8-jdk-alpine

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.2.1

RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget -qO gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mkdir -p /opt \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Adding gradle user and group" \
    && addgroup -S -g 1000 gradle \
    && adduser -D -S -G gradle -u 1000 -s /bin/ash gradle \
    && mkdir /home/gradle/.gradle \
    && chown -R gradle:gradle /home/gradle \
    \
    && echo "Symlinking root Gradle cache to gradle Gradle cache" \
    && ln -s /home/gradle/.gradle /root/.gradle

# RUN set -o errexit -o nounset 
# RUN echo "Downloading Gradle"
# RUN wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" 
# RUN echo "Checking download hash" 
# RUN echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - 
# RUN echo "Installing Gradle" \
#     && unzip gradle.zip \
#     && rm gradle.zip \
#     && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
#     && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle
    
# RUN echo "Adding gradle user and group" \
#     && groupadd --system --gid 1000 gradle \
#     && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
#     && mkdir /home/gradle/.gradle \
#     && chown --recursive gradle:gradle /home/gradle 

# RUN echo "Symlinking root Gradle cache to gradle Gradle cache" \
#     && ln -s /home/gradle/.gradle /root/.gradle




# Create Gradle volume
USER gradle
VOLUME "/home/gradle/.gradle"
WORKDIR /home/gradle

RUN set -o errexit -o nounset \
    && echo "Testing Gradle installation" \
    && gradle --version