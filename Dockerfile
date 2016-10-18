FROM tomcat:7-jre7

# Set Environment Variables
ENV OPENMRS_HOME /root/.OpenMRS
ENV OPENMRS_MODULES ${OPENMRS_HOME}/modules
ENV OPENMRS_PLATFORM_VERSION="1.11.4"
ENV OPENMRS_PLATFORM_URL="http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.11.4/openmrs.war/download"
ENV DOCKERIZE_VERSION v0.2.0
ENV DEFAULT_OPENMRS_DB_USER="openmrs"
ENV DEFAULT_OPENMRS_DB_PASS="openmrs"

# Download OpenMRS
RUN curl -L ${OPENMRS_PLATFORM_URL} \
         -o ${CATALINA_HOME}/webapps/openmrs.war \
    && mkdir -p ${OPENMRS_MODULES}


# Install dockerize
RUN curl -L "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" -o "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
    && tar -C /usr/local/bin -xzvf "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz"
# Copy templates
ADD openmrs-runtime.properties.tmpl "${CATALINA_HOME}/openmrs-runtime.properties.tmpl"
ADD setenv.sh.tmpl "${CATALINA_HOME}/bin/setenv.sh.tmpl"

CMD ["dockerize","-template","/usr/local/tomcat/bin/setenv.sh.tmpl:/usr/local/tomcat/bin/setenv.sh","-template","/usr/local/tomcat/openmrs-runtime.properties.tmpl:/usr/local/tomcat/openmrs-runtime.properties","-wait","tcp://db:3306","-timeout","1m15s","catalina.sh","run"]
