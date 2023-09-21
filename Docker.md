## Docker
- 도커 허브는 도커 이미지들이 저장된 저장소

### 도커 컨테이너와 이미지

**이미지**
- 애플리케이션을 빌드하면 이미지가 된다. 이미지를 실행하면 컨테이너가 된다.

**컨테이너**
- 이미지가 실행 되서 실제 프로세스에 자원을 할당받은 상태

**도커 이미지화**
- 우리는 지금부터 우리가 방금 만든 스프링 프로젝트를 도커 이미지로 만들어서 GCP에 존재하는 이미지 저장소에 우리의 도커 이미지를 푸시할 것이다.

- 도커 이미지는 다음과 같이 프로젝트 내부에 Dockerfile을 정의해서 만들어줄 수 있다. 

```java
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

```