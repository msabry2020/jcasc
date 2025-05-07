FROM jenkins/jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY install-plugins.txt .
RUN jenkins-plugin-cli --plugin-file install-plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml
