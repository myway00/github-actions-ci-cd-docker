# 첫 번째 스테이지: 빌드 환경 구성
FROM openjdk:17-alpine AS TEMP_BUILD_IMAGE
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME/
COPY gradle $APP_HOME/gradle/
RUN ./gradlew -x test --info || return 0
COPY . .
RUN ./gradlew -x test build

# 두 번째 스테이지: 실행 환경 구성
FROM openjdk:17-alpine
ENV ARTIFACT_NAME=cloud.jar
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/build/libs/$ARTIFACT_NAME .

EXPOSE 8080
ENTRYPOINT java -jar $ARTIFACT_NAME
