
# Creating a basic S2I builder image  

## Getting started  

### Files and Directories  
| File                   | Required? | Description                                                  |
|------------------------|-----------|--------------------------------------------------------------|
| Dockerfile             | Yes       | Defines the base builder image                               |
| s2i/bin/assemble       | Yes       | Script that builds the application                           |
| s2i/bin/run            | Yes       | Script that runs the application                             |
| test/test.r            | Yes       | Test application source code                                 |

#### Dockerfile
Create a *Dockerfile* that installs all of the necessary tools and libraries that are needed to build and run our application.  This file will also handle copying the s2i scripts into the created image.

#### S2I scripts

##### assemble
Create an *assemble* script that will build our application, e.g.:
- build python modules
- bundle install ruby gems
- setup application specific configuration

The script can also specify a way to restore any saved artifacts from the previous image.   

##### run
Create a *run* script that will start the application. 

##### Make the scripts executable 
Make sure that all of the scripts are executable by running *chmod +x s2i/bin/**

#### Create the builder image
The following command will create a builder image named s2i-mnist based on the Dockerfile that was created previously.
```
git clone https://github.com/changdukkim/r-s2i.git
docker build -t <Your Docker Image Names and Tags> .
#Example
#docker build -t docker-registry.default.svc:5000/openshift/r-s2i:latest .
docker push <Your Docker Image Names and Tags>
#Example
#docker push docker-registry.default.svc:5000/openshift/r-s2i:latest
```
Once the image has finished building, the command *s2i usage s2i-mnist* will print out the help info that was defined in the *usage* script.

#### Creating the application image
The application image combines the builder image with your applications source code, which is served using whatever application is installed via the *Dockerfile*, compiled using the *assemble* script, and run using the *run* script.
The following command will create the application image:
```
oc new-build --name r-binary --binary --strategy source --image-stream r-s2i
cd test/r-script-in-docker
oc start-build r-s2i --from-dir="." --follow -n <Project Name>
```
Using the logic defined in the *assemble* script, s2i will now create an application image using the builder image as a base and including the source code from the test/test-app directory. 

#### Running the application image
Running the application image is as simple as invoking the docker run command:
```
# docker run -t -i docker-registry.default.svc:5000/<Project Name>/r-binary:latest /bin/bash
# Execute R files 
> Rscript test.R
# or you can use R cmd
> R cmd
> x <- "Hello World"
> print(x)
Hello World 
```

#### Using the template
Deploying the application using the templates can be accomplished using the following command:
```
oc create -f r-s2i-template.yaml
```
You can find the created template at your Openshift catalog, Deploying the app with fill the parameters that templates need.
