Created By: Mike Lee<br />
Created On: 2024-05-04<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;This shell script allows MacOS/Linux users to create and deploy repeatable custom project<br />
&nbsp;&nbsp;&nbsp;&nbsp;templates using Visual Studio Code. Templates can be configured to install all required<br />
&nbsp;&nbsp;&nbsp;&nbsp;extensions and packages.
<br /><br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. In terminal, place shell script in your directory of choice.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To download directly to your current directory, use command:<br />
```
wget https://github.com/MikeLeeDeveloper/SampleCode/blob/main/Shell/SimpleVSCode/SimpleVSCode.sh
```

&nbsp;&nbsp;&nbsp;&nbsp;2. Open SimpleVSCode.sh in a text editor and replace {{Directory Path}} in the projectDirectory<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;variable to your desired project directory.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ex.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;projectDirectory="/Users/$USER/{{Directory Path}}"<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;projectDirectory="/Users/$USER/Documents/GitHub/"<br />
&nbsp;&nbsp;&nbsp;&nbsp;3. Execute shell script using command:<br />
```
sh SimpleVSCode.sh
```
<br /><br />
Create New Template<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Open SimpleVSCode.sh in a text editor<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. In the App Settings block, add the new project template's name to 'project' array.<br />
&nbsp;&nbsp;&nbsp;&nbsp;3. In the Project Template Settings block, use the following template to add your CLI<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;commands:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3a. The index of your new project template in the 'project' array followed by ')'.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3b. Commands to execute<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3c. Break switch using ';;'<br />
```
index)
Commands to execute
;;
```

Add template name to Project Template Array inside App Setting