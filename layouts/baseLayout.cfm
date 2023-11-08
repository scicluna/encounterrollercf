<!--- Structure to hold all encounters from all files --->
<cfset allEncounters = {}>

<!--- Get the list of markdown files in the 'encounters' folder --->
<cfdirectory directory="#ExpandPath('./encounters')#" action="list" name="mdFiles" filter="*.md">
<cfset fileNames = []>


<!--- Loop over each markdown file --->
<cfloop query="mdFiles">
    <!--- Read the contents of the current markdown file --->
    <cffile action="read" file="#ExpandPath('./encounters/' & mdFiles.name)#" variable="mdContent">
    <cfset fileNames.append(mdFiles.name)>

    <!--- Initialize an array for this file's encounters --->
    <cfset fileEncounters = []>

    <!--- Regex to find all the list items in the markdown --->
    <cfset contentArray = mdContent.split("\n")>

    <cfloop array="#contentArray#" index="line" >
        <cfset encounter = listToArray("#line#", "-" )>
        <cfset encounterName = reReplace(encounter[1],"\d+\.\s","")>
        <cfset description = encounter[2]>
        <cfset arrayAppend(fileEncounters, {name: encounterName, description: description})>
    </cfloop>

    <!--- Add the encounters from this file to the allEncounters structure --->
    <cfset allEncounters[mdFiles.name] = fileEncounters>
</cfloop>

<!--- Main Template --->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Template</title>
        <cfoutput>
            <!--- Dynmamically linked css file --->
            <link href="/#ListFirst(CGI.SCRIPT_NAME, "/")#/assets/css/ostyles.css" rel="stylesheet" />
        </cfoutput>
    </head>

    <body class="min-h-[100dvh] bg-slate-200">
        <!--- header --->
        <nav class="w-full flex justify-center">
        <cfoutput >
                <form class="p-2 flex items-center gap-1">

                    <select name="table" class="p-1">
                        <option value="">Select One</option>
                        <cfloop  array="#fileNames#" index="pagename">
                            <option value="#pagename#" <cfif structKeyExists(url, "table") AND (url.table EQ pagename)> selected="selected"</cfif> >#pagename#</option>
                        </cfloop>
                    </select>
                    <button class="bg-red-200 hover:bg-red-300 transition-all rounded-xl py-1 px-2" type="submit">Go</button>
                </form>
        </cfoutput>
        </nav>
        
        <!--- Content from nested layouts or pages will go here --->
        <section class="w-full flex flex-col justify-center items-center gap-2">
        
            <cfoutput >
                <cfif structKeyExists(url,"table") AND NOT url.table EQ "" >
                    <cfset count = 0>
                    <cfloop  array="#allEncounters[url.table]#" index="singleEncounter">
                        <cfset count++>
                        <p>#count#. #singleEncounter.name#</p>
                    </cfloop>
                </cfif>
            </cfoutput>
            <button class="bg-red-200 hover:bg-red-300 transition-all rounded-xl py-1 px-2" id="roller">Roll</button>
            <p id="result"></p>
        </section>

        <!--- footer --->
        <footer class="w-full">

        </footer>
    </body>

    <script defer>
        const encounters = <cfoutput>#serializeJSON(allEncounters)#</cfoutput>;
        const table = window.location.search.split('=')[1];
        const roller = document.getElementById("roller");
        const result = document.getElementById("result");
            roller.addEventListener("click", ()=>{
                const roll = Math.ceil(Math.random()*10);
                result.innerText = encounters[table][roll-1].NAME + "\n" + encounters[table][roll-1].DESCRIPTION;
            })
    </script>
</html>