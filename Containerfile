FROM jenkins/jenkins
ARG user=jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY install-plugins.txt .
RUN jenkins-plugin-cli --plugin-file install-plugins.txt
COPY create-seed-job.groovy /usr/share/jenkins/ref/init.groovy.d/create-seed-job.groovy
COPY casc.yaml /var/jenkins_home/casc.yaml
USER root
RUN chown -R ${user} /usr/share/jenkins/ref
USER ${user}