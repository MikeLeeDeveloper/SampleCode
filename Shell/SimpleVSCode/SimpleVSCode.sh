#!/bin/bash

# App Settings
# --------------------------------------------------------
# Directory
# ex. projectDirectory="/Users/$USER/Documents/GitHub/"
projectDirectory="/Users/$USER/{{Directory Path}}"

# .NET SDK Version
# ex. dotNetVersion="net8.0" 
dotNetVersion=$(dotnet --version)
dotNetVersion=$(echo $dotNetVersion | cut -d '.' -f 1,2)
dotNetVersion="net${dotNetVersion}"

# Project Templates
# New project templates can be added to this array
declare project
project[0]="Console APP (.NET Framework)"
project[1]="TO DO"
# --------------------------------------------------------

# Verify directory path is configured
if [ "$projectDirectory" == "/Users/$USER/{{Directory Path}}" ]
then
    echo "Please configure projectDirectory variable in SimpleVSCode.sh file."
    exit 1
fi

# Loop main if user does not confirm project
main=0
while [ $main == 0 ]
do
    # Clear terminal
    clear

    # Loop prompt for valid project template
    projectSelected=0
    while [ $projectSelected == 0 ]
    do
        # Display project options
        echo "Please select a project template:"
        for key in ${!project[@]}; 
        do
            keyOffset=$(($key + 1))
            echo "${keyOffset}. ${project[${key}]}"
        done
        echo "Enter exit() to quit."

        # Get user selection
        echo "------------------------------"
        read -p "Project Number: " projectNumber

        # Convert selection to lower for exit()
        projectNumber=$(echo $projectNumber | tr '[:upper:]' '[:lower:]')

        # Exit program
        if [ $projectNumber == "exit()" ]
        then
            exit 0
        # Non-numeric
        elif ! [[ $projectNumber =~ ^[0-9]+$ ]]
        then
            echo "Please select the NUMBER of the project you want to create."
        # Outside range
        elif [ $projectNumber -lt 1 ] || [ $projectNumber -gt ${#project[@]} ]
        then
            echo "Selection outside of project range"
        # Valid option
        else
            projectSelected=1
        fi

        # Break line
        echo
    done

    # Get project name
    read -p "Enter Project Name: " projectName
    projectDirectory="${projectDirectory}${projectName}"
    projectNumber=$((projectNumber - 1))

    # Confirm project settings
    echo
    echo "Please confirm settings:"
    echo "Project Template: ${project[${projectNumber}]}"
    echo "Project Name: ${projectName}"

    # Loop confirmation
    projectConfirm=0
    while [ $projectConfirm == 0 ]
    do
        read -p "Confirm? [y/n]: " confirmText
        confirmText=$(echo $confirmText | tr '[:upper:]' '[:lower:]')
        # Create project
        if [ $confirmText == "y" ]
        then 
            main=1
            break;
        # Restart main loop
        elif [ $confirmText == "n" ]
        then 
            break;
        fi
    done
done

echo

# Create project directory and naviate to it
mkdir $projectDirectory
cd $projectDirectory
echo "Directory Created: ${projectDirectory}"

# Project Template Settings
# ---------------------------------------------------------------------
case $projectNumber in 
    # Console APP (.NET Framework)
    0)
    dotnet new console --framework $dotNetVersion --use-program-main
    ;;
    # TO DO
    1)
    echo "TO DO: Project not configured"
    ;;
esac
# ---------------------------------------------------------------------

echo "Project Created: ${projectName}"

# Open project in VS Code
code .