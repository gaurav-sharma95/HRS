# Use a base Tomcat image
FROM tomcat:latest

# Remove the default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your JAR file into the webapps directory of Tomcat
#COPY demo-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT/demo-0.0.1-SNAPSHOT.war
COPY target/demo-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/

# Expose the port on which Tomcat will run
EXPOSE 8080

