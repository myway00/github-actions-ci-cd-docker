# 첫 번째 스테이지: 빌드 환경 구성
FROM openjdk:17-alpine AS TEMP_BUILD_IMAGE
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME/
COPY gradle $APP_HOME/gradle/
RUN ./gradlew -x test --info || return 0
COPY . .
# Gradle 빌드 스크립트를 복사하고 실행 권한을 설정합니다.
COPY ./gradlew ./gradlew
RUN chmod +x ./gradlew
# Gradle 빌드 명령문을 실행합니다.
RUN ./gradlew -x test build

# 두 번째 스테이지: 실행 환경 구성
FROM openjdk:17-alpine
ENV ARTIFACT_NAME=cloud.jar
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/build/libs/$ARTIFACT_NAME .

EXPOSE 8080
ENTRYPOINT java -jar $ARTIFACT_NAME
