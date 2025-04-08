## Artifact build stage
FROM maven AS buildstage

# Create working directory
RUN mkdir /opt/sample-webapp
WORKDIR /opt/sample-webapp

# Copy all source code into container
COPY . .

# Build the project and generate WAR file
RUN mvn clean install    ## artifact -- .war

### Tomcat deploy stage
FROM tomcat

# Set working directory to Tomcat webapps
WORKDIR webapps

# Copy built WAR file from previous stage into Tomcat
COPY --from=buildstage /opt/sample-webapp/target/*.war .

# Replace default ROOT app
RUN rm -rf ROOT && mv *.war ROOT.war

# Expose port 8080
EXPOSE 8080
