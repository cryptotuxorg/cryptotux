#!/bin/bash -x

### Corda ### 
# Still experimental

## Java environment 
sudo apt-get install -y --no-install-recommends default-jdk maven 

# Gradle
sudo add-apt-repository ppa:cwchien/gradle -y
sudo apt-get update
sudo apt -y install gradle

## Download sample programs
cd ~/Tutorials
git clone https://github.com/corda/samples-kotlin
git clone https://github.com/corda/samples-Java
cd

echo -e "$B\nCorda is ready to be used.$N"
echo -e "Sample programs are available in ~/Tutorials, try:"
echo -e "$C cd ~/Tutorials/samples-Java/Basic/cordapp-example/$N"
echo -e "$C ./gradlew deployNodes$N"