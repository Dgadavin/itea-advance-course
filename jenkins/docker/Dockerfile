FROM jenkins/jenkins:jdk11

USER root

ENV DEBIAN_FRONTEND=noninteractive

COPY jenkins-setup.groovy /usr/share/jenkins/ref/init.groovy.d/initial-setup.groovy

RUN /usr/local/bin/install-plugins.sh \
    git-parameter \
    dynamic_extended_choice_parameter \
    git \
    github \
    multiple-scms \
    envinject \
    ssh-agent \
    groovy \
    cloverphp \
    allure-jenkins-plugin \
    simple-theme-plugin \
    matrix-project \
    matrix-auth \
    job-dsl \
    workflow-aggregator

EXPOSE 8080
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]

# docker run -p 8080:8080 -e ENV=qa <image-name>
